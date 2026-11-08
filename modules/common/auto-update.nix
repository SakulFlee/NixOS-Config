{ config, pkgs, ... }:

let
  nixosRebuildBin = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
  gitBin = "${pkgs.git}/bin/git";
  systemctlBin = "${pkgs.systemd}/bin/systemctl";
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

  systemd.services.nixos-auto-update = {
    description = "Auto-update NixOS configuration from Git";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = with pkgs; [
      git
      nixos-rebuild
      openssh
      sudo
      libnotify
    ];

    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/etc/nixos";
    };

    script = ''
      cd /etc/nixos

      notify_all() {
        local title="$1" body="$2" urgency="$3"
        for bus in /run/user/*/bus; do
          [ -S "$bus" ] || continue
          uid="''${bus#/run/user/}"; uid="''${uid%%/*}"
          user=$(id -nu "$uid" 2>/dev/null) || continue
          sudo -u "$user" \
            DISPLAY=":0" DBUS_SESSION_BUS_ADDRESS="unix:path=$bus" \
            notify-send --app-name="NixOS Auto Updater" --urgency="$urgency" \
              "$title" "$body" >/dev/null 2>&1 || true
        done
      }

      ${gitBin} fetch origin main --quiet || echo "Auto-update: git fetch failed"
      BEHIND=$(${gitBin} rev-list --count HEAD..origin/main || echo 0)

      if [ "$BEHIND" -gt 0 ]; then
        echo "Auto-update: $BEHIND commits behind — updating..."

        if command -v notify-send &>/dev/null; then
          notify_all "NixOS Auto Updater" "Updates detected, rebuilding..." normal
        fi

        ${gitBin} merge --ff-only origin/main || echo "Auto-update: merge failed (diverged?)"

        # switch-to-configuration stops and restarts this very service, so an
        # interrupted run can still have its transient switch unit loaded when
        # this instance starts. nixos-rebuild reuses that unit name, so wait
        # for it to finish instead of failing with "already loaded".
        while ${systemctlBin} is-active --quiet nixos-rebuild-switch-to-configuration.service; do
          echo "Auto-update: waiting for the previous system switch to finish..."
          sleep 5
        done

        echo "--- nixos-rebuild start ---"
        EXIT_CODE=0
        ${nixosRebuildBin} switch --show-trace --print-build-logs || EXIT_CODE=$?
        # Exit code 4 means "switched successfully but some services failed" — treat as success
        [ "$EXIT_CODE" -eq 4 ] && EXIT_CODE=0
        echo "--- nixos-rebuild end (exit: $EXIT_CODE) ---"

        if command -v notify-send &>/dev/null; then
          if [ "$EXIT_CODE" -eq 0 ]; then
            notify_all "NixOS Auto Updater" "Rebuild completed successfully!" normal
          else
            notify_all "NixOS Auto Updater" "Rebuild failed! Check logs:\n\njournalctl -u nixos-auto-update" critical
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
