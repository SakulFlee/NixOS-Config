{ config, pkgs, ... }:

let
  nixosRebuildBin = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
  gitBin = "${pkgs.git}/bin/git";
in {
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

  systemd.services.nixos-auto-update = {
    description = "Auto-update NixOS configuration from Git";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = with pkgs; [ git nixos-rebuild openssh ];

    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/etc/nixos";
    };

    script = ''
      cd /etc/nixos

      ${gitBin} fetch origin main --quiet || echo "Auto-update: git fetch failed"
      BEHIND=$(${gitBin} rev-list --count HEAD..origin/main || echo 0)

      if [ "$BEHIND" -gt 0 ]; then
        echo "Auto-update: $BEHIND commits behind — updating..."

        if command -v notify-send &>/dev/null; then
          notify-send --app-name="NixOS Auto Updater" --urgency=normal \
            "NixOS Auto Updater" "Updates detected, rebuilding..." >/dev/null 2>&1 || true
        fi

        ${gitBin} merge --ff-only origin/main || echo "Auto-update: merge failed (diverged?)"

        echo "--- nixos-rebuild start ---"
        EXIT_CODE=0
        ${nixosRebuildBin} switch --show-trace --print-build-logs || EXIT_CODE=$?
        # Exit code 4 means "switched successfully but some services failed" — treat as success
        [ "$EXIT_CODE" -eq 4 ] && EXIT_CODE=0
        echo "--- nixos-rebuild end (exit: $EXIT_CODE) ---"

        if command -v notify-send &>/dev/null; then
          if [ "$EXIT_CODE" -eq 0 ]; then
            notify-send --app-name="NixOS Auto Updater" --urgency=normal \
              "NixOS Auto Updater" "Rebuild completed successfully!" >/dev/null 2>&1 || true
          else
            notify-send --app-name="NixOS Auto Updater" --urgency=critical \
              "NixOS Auto Updater" "Rebuild failed! Check logs:\n\njournalctl -u nixos-auto-update" >/dev/null 2>&1 || true
          fi
        fi
      fi
    '';
  };

  systemd.timers.nixos-auto-update = {
    description = "Hourly timer for NixOS auto-update";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "1h";
      RandomizedDelaySec = "5min";
    };
  };
}
