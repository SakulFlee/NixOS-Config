{ address, allowedIPs }:
{
  pkgs,
  config,
  lib,
  ...
}:
let
  serverPublicKey = "g51V82hlZ/Xu2gLoX7hqIPVSU4GnRmkED2ilxRla+XA=";
  secretName = "wireguard_${config.networking.hostName}_private_key";
  pskSecretName = "wireguard_${config.networking.hostName}_preshared_key";
in
{
  sops.secrets.${secretName} = {
    key = "wireguard/${config.networking.hostName}/private_key";
  };
  sops.secrets.${pskSecretName} = {
    key = "wireguard/${config.networking.hostName}/preshared_key";
  };

  networking.wg-quick.interfaces.wg0 = {
    address = address;
    privateKeyFile = config.sops.secrets.${secretName}.path;
    mtu = 1420;
    peers = [
      {
        publicKey = serverPublicKey;
        presharedKeyFile = config.sops.secrets.${pskSecretName}.path;
        endpoint = "wg.sakul-flee.de:51820";
        allowedIPs = allowedIPs;
        persistentKeepalive = 25;
      }
    ];
    postUp = ''
      # When we are on the home LAN, the directly-connected /24 route must win
      # over the WireGuard route, otherwise all LAN hosts (including the
      # HomeLab) get blackholed through the tunnel.
      if ip -4 addr show | grep -q 'inet 192\.168\.178\.'; then
        ip route del 192.168.178.0/24 dev wg0 2>/dev/null || true
        # Keep the HomeLab host itself on the tunnel while leaving the rest of
        # the LAN direct. This is more specific than the connected /24 route,
        # so Caddy sees the VPN source address (100.64.0.x) for host vhosts.
        ip route replace 192.168.178.200/32 dev wg0
      fi
    '';
    preDown = ''
      ip route del 192.168.178.200/32 dev wg0 2>/dev/null || true
    '';
  };
}
