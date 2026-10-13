{ address, allowedIPs, privateKey }: { pkgs, config, lib, ... }:
let
  serverPublicKey = "tDj18GzgpKzFsfu0JdltiienO5uvJDw1e4Hwq1551DI=";
in {
  networking.wg-quick.interfaces.wg0 = {
    address = address;
    privateKeyFile = privateKey;
    dns = [ "192.168.178.200" ];
    peers = [{
      publicKey = serverPublicKey;
      endpoint = "wg.sakul-flee.de:51820";
      allowedIPs = allowedIPs;
      persistentKeepalive = 25;
    }];
    postUp = ''
      if ping -c 1 -W 1 192.168.178.200 &>/dev/null; then
        ${pkgs.wireguard-tools}/bin/wg set wg0 peer ${serverPublicKey} endpoint 192.168.178.200:51820
      fi
    '';
  };
}
