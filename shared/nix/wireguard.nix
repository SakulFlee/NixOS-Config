{ config, lib, ... }:
let
  hostCfg = {
    "Evil-Donkey" = {
      ips = [ "10.100.0.2/32" ];
      publicKey = "tDj18GzgpKzFsfu0JdltiienO5uvJDw1e4Hwq1551DI=";
    };
    "Cindry" = {
      ips = [ "10.100.0.3/32" ];
      publicKey = "ClMVYG1CLPUe4O8gWKbriZYe46vzHm5jV0vL8sCJsDI=";
    };
  };
  this = hostCfg.${config.networking.hostName} or (throw "wireguard.nix: unknown host ${config.networking.hostName}");
in {
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."wireguard_admin_private_key" = { };

  networking.wireguard.interfaces.wg0 = {
    ips = this.ips;
    privateKeyFile = config.sops.secrets.wireguard_admin_private_key.path;
    peers = [{
      publicKey = this.publicKey;
      endpoint = "vpn.sakul-flee.de:51820";
      allowedIPs = [ "10.0.0.0/24" "192.168.178.0/24" "fdbe::/64" ];
      persistentKeepalive = 25;
    }];
  };
}