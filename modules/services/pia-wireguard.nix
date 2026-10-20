{ config, ... }: {
  # Complete wg-quick config for PIA's WireGuard endpoint, stored with sops.
  # Must contain [Interface] Address/DNS/PrivateKey and a [Peer] with an
  # IP:port Endpoint (vpn-confinement resolves it by pinging).
  sops.secrets."pia_wg_conf" = {
    key = "pia/wireguard";
    mode = "0600";
  };

  vpnNamespaces.pia = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."pia_wg_conf".path;
    portMappings = [
      {
        from = 8080;
        to = 8080;
        protocol = "tcp";
      }
    ];
  };

  # Headless qBittorrent, confined to the PIA namespace. Reach the WebUI from
  # the host at http://192.168.15.1:8080 (or http://localhost:8080).
  services.qbittorrent = {
    enable = true;
    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent.Session.Interface = "pia0";
      Preferences.WebUI.Port = 8080;
      Preferences.WebUI.Address = "*";
    };
    extraArgs = [ "--confirm-legal-notice" ];
  };

  systemd.services.qbittorrent.vpnConfinement = {
    enable = true;
    vpnNamespace = "pia";
  };
}
