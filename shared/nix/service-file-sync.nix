{ pkgs, ... }: {
  systemd.user.services.freefilesync-watcher = {
    description = "FreeFileSync Sync Watcher";
    documentation = [
      "man:inotifywait(1)"
      "man:FreeFileSync(1)"
    ];
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";

      # Ensure the target Sync directory exists before running the script
      ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/mkdir -p $HOME/Sync'";

      ExecStart = "${pkgs.writeShellScript "freefilesync-watcher" ''
        # Make sure the script can find both inotify tools AND FreeFileSync
        PATH="${pkgs.lib.makeBinPath [ pkgs.inotify-tools pkgs.freefilesync ]}:$PATH"

        FOLDER_TO_WATCH="$HOME/Sync"
        FFS_SCRIPT="$HOME/Sync/Sync.ffs_batch"
        
        sync_files() {
            FreeFileSync "$FFS_SCRIPT"
        }
        
        echo "Initial startup sync ..."
        sync_files
        
        while true; do
          inotifywait \
            --recursive \
            --timeout 3600 \
            --event modify \
            --event close_write \
            --event move \
            --event move_self \
            --event create \
            --event delete \
            --event delete_self \
            "$FOLDER_TO_WATCH"
        
          if [ $? -ne 1 ]; then
            echo "Change detected! Syncing ..."
            sync_files
          fi
        done
        
        echo "Script exiting ..."
      ''}";
      
      Restart = "always";
      RestartSec = 5;
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
