{ config, ... }: {
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
}
