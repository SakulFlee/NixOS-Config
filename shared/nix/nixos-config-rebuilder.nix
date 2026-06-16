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
      
      # Ensure it recognizes /etc/nixos as a safe repository even when run by root
      ${pkgs.git}/bin/git config --global --add safe.directory /etc/nixos

      # Fetch the latest state from your origin branch silently
      ${pkgs.git}/bin/git fetch origin --quiet

      # Extract the local vs remote commit hashes (Assuming your main branch is 'main')
      LOCAL=$(${pkgs.git}/bin/git rev-parse @)
      REMOTE=$(${pkgs.git}/bin/git rev-parse @{u})

      # Compare them. If they do not match, we are out of sync!
      if [ "$LOCAL" != "$REMOTE" ]; then
        printf "Upstream updates detected! Launching build window...\n"

        # Reach down into your active user GUI session to spawn Konsole.
        # IF the user is not logged in, this will FAIL.
        ${pkgs.systemd}/bin/systemd-run \
          --user \
          --machine=sakulflee@.host \
          --collect \
          --setenv=DISPLAY=:0 \
          ${pkgs.kdePackages.konsole}/bin/konsole -e ${pkgs.bash}/bin/bash -c '
            printf "========== AUTOMATIC GIT PULL & NIXOS REBUILD ==========\n\n"
            cd /etc/nixos
            
            printf "Merging upstream commits...\n"
            ${pkgs.git}/bin/git pull origin main
            
            printf "\nExecuting system switch...\n"
            ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --show-trace
            
            printf "\nFinished! Press any key to close this terminal..."
            read -n 1
          '
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
