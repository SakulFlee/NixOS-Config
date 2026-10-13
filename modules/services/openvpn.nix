{ config, lib, pkgs, ... }:

let
  # Load secrets from SOPS
  vpn_secrets = sops.secrets {
    path = ../../secrets.yaml;
  };

  # OpenVPN Credentials (shared across all hosts)
  vpn_public_creds = vpn_secrets.openvpn.pia;
in
{
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
}
