{ config, lib, ... }:
let
  hostCfg = {
    "Evil-Donkey" = {
      address = [ "10.100.0.2/32" ];
      publicKey = "tDj18GzgpKzFsfu0JdltiienO5uvJDw1e4Hwq1551DI=";
    };
    "Cindry" = {
      address = [ "10.100.0.3/32" ];
      publicKey = "ClMVYG1CLPUe4O8gWKbriZYe46vzHm5jV0vL8sCJsDI=";
    };
  };
  this = hostCfg.${config.networking.hostName} or (throw "wireguard.nix: unknown host ${config.networking.hostName}");
in {
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."wireguard_admin_private_key" = { };

  networking.wg-quick.interfaces.wg0 = {
    address = this.address;
    privateKeyFile = config.sops.secrets.wireguard_admin_private_key.path;
    dns = [ "10.0.0.116" ];
    peers = [{
      publicKey = this.publicKey;
      endpoint = "vpn.sakul-flee.de:51820";
      allowedIPs = [ "0.0.0.0/0" "::/0" ];
      persistentKeepalive = 25;
    }];
    table = null; # Don't auto-add routes
    postUp = ''
      # Keep the handshake route direct (bypass tunnel)
      ip route add 192.168.178.200/32 dev enp9s0 2>/dev/null || true
      
      # Internet through tunnel
      ip route add 0.0.0.0/1 dev wg0
      ip route add 128.0.0.0/1 dev wg0
      
      # Containers through tunnel
      ip route add 10.0.0.0/24 dev wg0
      ip route add fdbe::/64 dev wg0
    '';
    postDown = ''
      ip route del 0.0.0.0/1 dev wg0 2>/dev/null || true
      ip route del 128.0.0.0/1 dev wg0 2>/dev/null || true
      ip route del 10.0.0.0/24 dev wg0 2>/dev/null || true
      ip route del fdbe::/64 dev wg0 2>/dev/null || true
    '';
  };
}
