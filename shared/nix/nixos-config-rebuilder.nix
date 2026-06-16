{ pkgs, ... }: {
  systemd.services.nixos-config-git-watcher = {
    description = "Check git upstream for configuration changes and rebuild";
    
    serviceConfig = {
      Type = "oneshot";
      User = "root"; # Root to prevent password prompts
    };

    path = with pkgs; [ git openssh nixos-rebuild kdePackages.konsole bash systemd ];

    script = ''
      cd /etc/nixos
      ${pkgs.git}/bin/git config --global --add safe.directory /etc/nixos

      # 1. Fetch upstream changes silently
      ${pkgs.git}/bin/git fetch origin --quiet

      # 2. Grab hashes
      LOCAL=$(${pkgs.git}/bin/git rev-parse @)
      REMOTE=$(${pkgs.git}/bin/git rev-parse @{u})

      if [ "$LOCAL" != "$REMOTE" ]; then
        printf "Upstream updates detected!\n"

        # Check if your user is logged into the graphical session
        if ${pkgs.systemd}/bin/loginctl list-users | grep -q "sakulflee"; then
          printf "User logged in. Spawning privileged visual terminal...\n"
          
          # WEIRD LINUX MAGIC
          # Opens a terminal on the active display logged in as "root"
          ${pkgs.systemd}/bin/systemd-run \
            --uid=0 \
            --collect \
            --setenv=DISPLAY=:0 \
            --setenv=XDG_RUNTIME_DIR=/run/user/1000 \
            ${pkgs.kdePackages.konsole}/bin/konsole -e ${pkgs.bash}/bin/bash -c '
              printf "========== AUTOMATIC ROOT GIT PULL & REBUILD ==========\n\n"
              cd /etc/nixos
              
              printf "Pulling upstream commits as root...\n"
              ${pkgs.git}/bin/git pull origin main
              
              printf "\nExecuting system switch as root (No password required)...\n"
              ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --show-trace
              
              printf "\nFinished! Press any key to close this terminal..."
              read -n 1
            '
        else
          printf "No active user session. Rebuilding headlessly as root...\n"
          ${pkgs.git}/bin/git pull origin main
          ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch
        fi
      fi
    '';
  };

  # Triggers regularly to watch for changes
  systemd.timers.nixos-config-git-watcher = {
    description = "Timer to poll /etc/nixos git status every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";       # Wait 2 minutes after boot before first check
      OnUnitActiveSec = "5min"; # Check every 5 minutes continuously
    };
  };
}
