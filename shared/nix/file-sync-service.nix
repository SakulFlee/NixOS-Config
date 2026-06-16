{ pkgs, ... }: {
  systemd.user.services.freefilesync-watcher = {
    Unit = {
      Description = "FreeFileSync Sync Watcher";
      Documentation = [
        "man:inotifywait(1)"
        "man:FreeFileSync(1)"
      ];
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "freefilesync-watcher" ''
        PATH="${pkgs.lib.makeBinPath [ pkgs.inotify-tools ]}:$PATH"

        FOLDER_TO_WATCH="$HOME/Sync"
        FFS_SCRIPT="$HOME/Sync/Sync.ffs_batch"
        
        sync() {
            FreeFileSync "$FFS_SCRIPT"
        }
        
        echo "Initial startup sync ..."
        sync
        
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
            sync
          fi
        done
        
        echo "Script exiting ..."
      ''}";
      
      Restart = "always";
      RestartSec = 5;
      StandardOutput = "journal";
      StandardError = "journal";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
