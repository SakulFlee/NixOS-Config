{ config, pkgs, ... }: 

let 
  nixosRebuildBin = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
  gitBin = "${pkgs.git}/bin/git";
in 
{
  security.sudo.extraRules = [
    {
      users = [ "sakulflee" ];
      commands = [
        {
          command = nixosRebuildBin;
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  systemd.user.services.nixos-rebuilder = {
    description = "Check git upstream for configuration changes and rebuild";
    
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    path = with pkgs; [ git openssh nixos-rebuild kitty bash ];

    serviceConfig = {
      Type = "oneshot";
      PassEnvironment = [ "DISPLAY" "WAYLAND_DISPLAY" "XDG_RUNTIME_DIR" ];

      # Prevents Kitty from getting killed below
      KillMode = "process";
    };

    script = ''
      cd /etc/nixos

      ${gitBin} fetch origin --quiet

      LOCAL=$(${gitBin} rev-parse @)
      REMOTE=$(${gitBin} rev-parse @{u})

      if [ "$LOCAL" != "$REMOTE" ]; then
        echo "Upstream updates detected!"

        # Note: Kitty runs detached here to free the service and prevent a deadlock!
        kitty --title="NixOS Rebuilder" -- bash -c '
          printf "========== NixOS Rebuilder ==========\n\n"
          cd /etc/nixos
          
          printf "Pulling changes from Git...\n"
          ${gitBin} pull origin main
          
          printf "\nExecuting NixOS configuration switch...\n"
          ${config.security.wrapperDir}/sudo ${nixosRebuildBin} switch --show-trace
          
          printf "\nFinished! Press any key to close this terminal..."
          read -n 1
        ' &
        
        disown
      fi
    '';
  };

  systemd.user.timers.nixos-rebuilder = {
    description = "Timer to poll /etc/nixos git status every 5 minutes";
    
    # FIXED: Binds the timer cycle to the active desktop environment session context
    wantedBy = [ "graphical-session.target" ];
    
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
    };
  };
}
