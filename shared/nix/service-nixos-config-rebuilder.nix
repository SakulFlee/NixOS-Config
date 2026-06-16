{ pkgs, ... }: {

  # 1. Provide a password-less rule allowing your user to run the rebuild
  security.sudo.extraRules = [
    {
      users = [ "sakulflee" ]; # REPLACE with your actual username
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # 2. Define the Timer and Service inside User Space
  systemd.user.services.nixos-gitwatch = {
    description = "Check git upstream for configuration changes and rebuild";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    path = with pkgs; [ git openssh nixos-rebuild kdePackages.konsole bash sudo ];

    serviceConfig = {
      Type = "oneshot";
      # Runs natively as you, giving it direct authority to throw windows onto your screen
    };

    script = ''
      cd /etc/nixos

      # 1. Fetch upstream changes silently using your user's SSH keys/credentials
      git fetch origin --quiet

      # 2. Grab hashes
      LOCAL=$(git rev-parse @)
      REMOTE=$(git rev-parse @{u})

      if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Upstream updates detected!"

        # Fire off Konsole instantly. No display environment wrappers needed 
        # because the service already lives inside your user graphical slice!
        konsole -e bash -c '
          printf "========== AUTOMATIC PRIVILEGED REBUILD ==========\n\n"
          cd /etc/nixos
          
          printf "Pulling changes from Git...\n"
          sudo git pull origin main
          
          printf "\nExecuting NixOS configuration switch...\n"
          sudo nixos-rebuild switch --show-trace
          
          printf "\nFinished! Press any key to close this terminal..."
          read -n 1
        '
      fi
    '';
  };

  # 3. Trigger the user service every 5 minutes
  systemd.user.timers.nixos-gitwatch = {
    description = "Timer to poll /etc/nixos git status every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
    };
  };
}
