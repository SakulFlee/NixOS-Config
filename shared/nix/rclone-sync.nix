{ config, pkgs, ... }:
let
  # --- CONFIGURATION VARIABLES ---
  username = "sakulflee"; 
  localDir = "/home/${username}/Sync";
  remoteDir = "NASSMB:personal_folder/";
  cooldown = "30";
  checkInterval = "1800";
  stateDir = "/home/${username}/.config/rclone";
  errorLock = "${stateDir}/bisync-error.lock";

  rcloneWatcherScript = pkgs.writeShellScriptBin "rclone-watcher" ''
    PATH=${pkgs.lib.makeBinPath [ pkgs.rclone pkgs.inotify-tools pkgs.libnotify pkgs.coreutils pkgs.gnugrep ]}:$PATH

    # --- RECONCILE SOPS SECRETS INTO RCLONE ENVIRONMENT VARIABLES ---
    export RCLONE_CONFIG_NAS_SMB_TYPE="smb"
    export RCLONE_CONFIG_NAS_SMB_HOST="$smb_host"
    export RCLONE_CONFIG_NAS_SMB_USER="$smb_user"
    export RCLONE_CONFIG_NAS_SMB_PASS="$smb_pass"

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

        # DYNAMIC D-BUS DETECTION
        # If DBUS_SESSION_BUS_ADDRESS is missing or invalid, scrape it from a running user process
        if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] || [[ "$DBUS_SESSION_BUS_ADDRESS" == *"No such file"* ]]; then
            # Find a process owned by the current user that is guaranteed to hold the live DBUS variable
            local user_pid=$(pgrep -u "$USER" -x "systemd" | head -n 1)
            if [ -n "$user_pid" ]; then
                export DBUS_SESSION_BUS_ADDRESS=$(grep -z '^DBUS_SESSION_BUS_ADDRESS=' /proc/"$user_pid"/environ | sed 's/^DBUS_SESSION_BUS_ADDRESS=//')
            fi
        fi

        if command -v notify-send &> /dev/null; then
            notify-send -u "$urgency" -i "emblem-synchronizing" "$title" "$message"
        fi
    }

    sync() {
      rclone bisync "$LOCAL_DIR" "$REMOTE_DIR" --conflict-resolve newer --check-access
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

    echo "Initial sync for $LOCAL_DIR ..."
    notify "normal" "Rclone Watcher" "Initial sync started"
    sync

    echo "Starting rclone bisync watcher for $LOCAL_DIR ..."
    notify "normal" "Rclone Watcher" "Monitoring started safely for local changes."

    while true; do
        if [ -f "$ERROR_LOCK" ]; then exit 0; fi

        # Wait for local change or force timeout check
        inotifywait -r -t "$CHECK_INTERVAL" -e modify,create,delete,move "$LOCAL_DIR" &> /dev/null
        
        sleep "$COOLDOWN"
        
        notify "low" "Rclone Syncing" "Updating files with remote storage..."
        echo "Sync triggered at $(date)"

        if sync; then
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
  sops.secrets."smb_user" = { owner = username; };
  sops.secrets."smb_pass" = { owner = username; };
  sops.secrets."smb_host" = { owner = username; };

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
        "${config.sops.secrets."smb_user".path}"
        "${config.sops.secrets."smb_pass".path}"
        "${config.sops.secrets."smb_host".path}"
      ];
    };
  };
}
