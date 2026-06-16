{ pkgs, ... }: {
  security.sudo.extraRules = [
    {
      users = [ "sakulflee" ];
      commands = [
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  systemd.user.services.nixos-rebuilder = {
    description = "Check git upstream for configuration changes and rebuild";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    path = with pkgs; [ git openssh nixos-rebuild kitty bash sudo ];

    serviceConfig = {
      Type = "oneshot";
      PassEnvironment = [ "DISPLAY" "WAYLAND_DISPLAY" "XDG_RUNTIME_DIR" ];
    };

    script = ''
      cd /etc/nixos

      git fetch origin --quiet

      LOCAL=$(git rev-parse @)
      REMOTE=$(git rev-parse @{u})

      if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Upstream updates detected!"

        # Open Terminal to show progress
        kitty --title="NixOS Rebuilder" -- bash -c '
          printf "========== NixOS Rebuilder ==========\n\n"
          cd /etc/nixos
          
          printf "Pulling changes from Git...\n"
          git pull origin main
          
          printf "\nExecuting NixOS configuration switch...\n"
          /run/wrappers/bin/sudo nixos-rebuild switch --show-trace
          
          printf "\nFinished! Press any key to close this terminal..."
          read -n 1
        '
      fi
    '';
  };

  # 3. Trigger the user service every 5 minutes
  systemd.user.timers.nixos-rebuilder = {
    description = "Timer to poll /etc/nixos git status every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
    };
  };
}
