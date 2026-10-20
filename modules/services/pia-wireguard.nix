{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Complete wg-quick config for PIA's WireGuard endpoint, stored with sops.
  # Must contain [Interface] Address/DNS/PrivateKey and a [Peer] with an
  # IP:port Endpoint (vpn-confinement resolves it by pinging).
  sops.secrets."pia_wg_conf" = {
    key = "pia/wireguard";
    mode = "0600";
  };

  # The namespace is used by GUI applications launched through `vpn-run`
  # (see modules/desktop/vpn-gui.nix). No ports are published.
  vpnNamespaces.pia = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."pia_wg_conf".path;
  };

  # The namespace is created on demand by vpn-run, not at boot.
  systemd.services.pia.wantedBy = lib.mkForce [ ];

  # Stop the namespace once no confined process has been running for a while.
  # The timestamp file makes this a two-minute idle timeout even though the
  # check itself runs every minute.
  systemd.services.pia-idle-stop = {
    serviceConfig.Type = "oneshot";
    path = [
      config.systemd.package
      pkgs.iproute2
      pkgs.coreutils
    ];
    script = ''
      set -eu

      systemctl is-active --quiet pia.service || {
        rm -f /run/pia-idle-since
        exit 0
      }

      pids="$(ip netns pids pia 2>/dev/null || true)"
      if [ -n "$pids" ]; then
        rm -f /run/pia-idle-since
        exit 0
      fi

      if [ ! -e /run/pia-idle-since ]; then
        touch /run/pia-idle-since
        exit 0
      fi

      [ $(( $(date +%s) - $(stat -c %Y /run/pia-idle-since) )) -ge 120 ] || exit 0

      systemctl stop pia.service
      rm -f /run/pia-idle-since
    '';
  };

  systemd.timers.pia-idle-stop = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1min";
    };
  };
}
