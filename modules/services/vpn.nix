{ config, lib, pkgs, ... }:

let
  # Load secrets from SOPS
  vpn_secrets = sops.secrets {
    path = ../../secrets.yaml;
  };

  # Hostname specific lookup for WireGuard private key
  # e.g., Dendra -> wireguard.Dendra.private_key
  host_key = vpn_secrets.wireguard.${config.networking.hostName.name};

  # OpenVPN Credentials (shared across all hosts)
  vpn_public_creds = vpn_secrets.openvpn.pia;
in
{
  services.vpn = {
    enable = true;

    # WireGuard Configuration
    wireguard.interfaces.vpn_wg = {
      privateKey = host_key;
      # Static configuration shared by all hosts
      port = 51820;
      allowedIPs = [ "192.168.178.0/24" "100.64.0.0/10" ];
      dns = "192.168.178.200";
      mtu = 1420;
      endpoint = "wg.sakul-flee.de:51820";
      # Peer constants (public & preshared key)
      peerPublicKey = "g51V82hlZ/Xu2gLoX7hqIPVSU4GnRmkED2ilxRla+XA=";
      presharedKey = "SNBNYZeSyonH2sTDsUcMHeLvZwoL4dUkSylRa4LyWQk=";
    };

    # OpenVPN Configuration
    systemd.services.openvpn-client = {
      description = "OpenVPN Client";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Environment = "OPENVPN_USER=${vpn_public_creds.username}"
        Environment = "OPENVPN_PASS=${vpn_public_creds.password}"
        ExecStart = "${pkgs.openvpn}/bin/openvpn --config /etc/openvpn/client/pia.conf"
        Restart = "on-failure"
        RestartSec = 5
      };
    };
  };
}
