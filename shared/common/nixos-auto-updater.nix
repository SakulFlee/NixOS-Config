{ config, pkgs, ... }: 

let 
  nixosRebuildBin = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
  gitBin = "${pkgs.git}/bin/git";
  notifyBin = "${pkgs.libnotify}/bin/notify-send";
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

  systemd.user.services.nixos-auto-updater = {
    description = "Check git upstream for configuration changes and rebuild";
    
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    path = with pkgs; [ git openssh nixos-rebuild libnotify ];

    serviceConfig = {
      Type = "oneshot";
      PassEnvironment = [ "DISPLAY" "WAYLAND_DISPLAY" "XDG_RUNTIME_DIR" ];
    };

    script = ''
      cd /etc/nixos

      ${gitBin} fetch origin --quiet 2>/dev/null || true
      BEHIND=$(${gitBin} rev-list --count @..@{u} 2>/dev/null || echo 0)

      if [ "$BEHIND" -gt 0 ]; then
        echo "Upstream updates detected!"

        ${notifyBin} --app-name="NixOS Auto Updater" --urgency=normal \
          "NixOS Auto Updater" "Updates detected, rebuilding..." >/dev/null 2>&1 || true

        ${gitBin} pull origin main

        ${config.security.wrapperDir}/sudo ${nixosRebuildBin} switch --show-trace
        EXIT_CODE=$?

        if [ "$EXIT_CODE" -eq 0 ]; then
          ${notifyBin} --app-name="NixOS Auto Updater" --urgency=normal \
            "NixOS Auto Updater" "Rebuild completed successfully!" >/dev/null 2>&1 || true
        else
          ${notifyBin} --app-name="NixOS Auto Updater" --urgency=critical \
            "NixOS Auto Updater" "Rebuild failed! Check logs:\n\njournalctl --user -u nixos-rebuilder" >/dev/null 2>&1 || true
        fi
      fi
    '';
  };

  systemd.user.timers.nixos-rebuilder = {
    description = "Timer to poll /etc/nixos git status every hour";
    
    # FIXED: Binds the timer cycle to the active desktop environment session context
    wantedBy = [ "graphical-session.target" ];
    
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1h";
    };
  };
}
