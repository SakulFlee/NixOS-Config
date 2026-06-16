{ config, pkgs, ... }:
let
  # --- CONFIGURATION VARIABLES ---
  username = "sakulflee"; 
  localDir = "/home/${username}/Sync";
  remoteDir = "NAS-SMB:personal_folder/";
  cooldown = "30";
  checkInterval = "1800";
  stateDir = "/home/${username}/.config/rclone";
  errorLock = "${stateDir}/bisync-error.lock";

  rcloneWatcherScript = pkgs.writeShellScriptBin "rclone-watcher" ''
    PATH=${pkgs.lib.makeBinPath [ pkgs.rclone pkgs.inotify-tools pkgs.libnotify pkgs.coreutils pkgs.gnugrep ]}:$PATH

    LOCAL_DIR="${localDir}"
    REMOTE_DIR="${remoteDir}"
    COOLDOWN="${cooldown}"
    CHECK_INTERVAL="${checkInterval}"
    STATE_DIR="${stateDir}"
    ERROR_LOCK="${errorLock}"

    notify() {
        local urgency="$1"
        local title="$2"
        local message="$3"
        if command -v notify-send &> /dev/null; then
            notify-send -u "$urgency" -i "emblem-synchronizing" "$title" "$message"
        fi
    }

    # Check for error lock
    if [ -f "$ERROR_LOCK" ]; then
        echo "========================================================================="
        echo "CRITICAL ERROR: Auto-sync is DISABLED because a previous sync failed."
        echo "To protect your data, this script will refuse to run."
        echo "1. Inspect your logs: journalctl --user -u rclone-watcher.service -n 50"
        echo "2. Fix the conflict or run a manual rclone bisync ... --resync"
        echo "3. Clear this lock by running: rm $ERROR_LOCK"
        echo "========================================================================="
        exit 0
    fi

    mkdir -p "$STATE_DIR"
    if [ ! -d "$LOCAL_DIR" ]; then
        echo "Error: Local directory $LOCAL_DIR does not exist."
        exit 1
    fi

    echo "Starting rclone bisync watcher for $LOCAL_DIR..."
    notify "normal" "Rclone Watcher" "Monitoring started safely for local changes."

    while true; do
        if [ -f "$ERROR_LOCK" ]; then exit 0; fi

        # Wait for local change or force timeout check
        inotifywait -r -t "$CHECK_INTERVAL" -e modify,create,delete,move "$LOCAL_DIR" &> /dev/null
        
        sleep "$COOLDOWN"
        
        notify "low" "Rclone Syncing" "Updating files with remote storage..."
        echo "Sync triggered at $(date)"

        if rclone bisync "$LOCAL_DIR" "$REMOTE_DIR" --conflict-resolve newer --check-access; then
            echo "Sync successful."
            notify "normal" "Rclone Sync" "Files are fully up to date."
        else
            echo "-------------------------------------------------------------------------"
            echo "CRITICAL: Sync encountered an error or conflict!"
            echo "Tripping the circuit breaker. Auto-sync is frozen."
            echo "-------------------------------------------------------------------------"
            
            touch "$ERROR_LOCK"
            notify "critical" "⚠️ RCLONE SYNC CRITICAL ERROR" "Auto-sync has been frozen to prevent data loss."
            exit 0
        fi
        
        sleep 3
    done
  '';
in
{
  # Setup SOPS
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."smb-user" = { owner = username; };
  sops.secrets."smb-pass" = { owner = username; };
  sops.secrets."smb-host" = { owner = username; };

  # Ensure Rclone and required packages are installed system-wide
  environment.systemPackages = [ pkgs.rclone pkgs.inotify-tools ];

  # Define the Systemd User Service
  systemd.user.services.rclone-watcher = {
    description = "Automated Rclone Bisync Watcher";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    
    serviceConfig = {
      ExecStart = "${rcloneWatcherScript}/bin/rclone-watcher";
      Restart = "on-failure";
      RestartSec = "10s";
      
      # Dynamically inject the credentials as environment variables
      EnvironmentFile = [
        "${config.sops.secrets."smb-user".path}"
        "${config.sops.secrets."smb-pass".path}"
        "${config.sops.secrets."smb-host".path}"
      ];
    };

    # Set up the Rclone-specific configuration variables using the SOPS outputs
    environment = {
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/${toString config.users.users.${username}.uid}/bus";
      
      # Dynamically generate rclone config via env-vars
      RCLONE_CONFIG_NAS-SMB_TYPE = "smb";
      RCLONE_CONFIG_NAS-SMB_HOST = "$smb-host";
      RCLONE_CONFIG_NAS-SMB_USER = "$smb-user";
      RCLONE_CONFIG_NAS-SMB_PASS = "$smb-pass"; 
    };
  };
}
