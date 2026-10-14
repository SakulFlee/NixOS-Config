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
    dns = [ "192.168.178.200" ];
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
      if ip -4 addr show | grep -q 'inet 192\.168\.178\.'; then
        ip route del 192.168.178.0/24 dev wg0 2>/dev/null || true
        ip route add 192.168.178.200/32 dev wg0 2>/dev/null || true
      fi
    '';
  };
}
