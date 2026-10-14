{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./syncthing.nix
    ../../users/_.nix
    ../../modules/common/_.nix
    #    ../../modules/common/optionals/openrgb.nix
    #    ../../modules/common/optionals/vbox.nix
    
    (import ../../modules/packages/_.nix {
      users = [ "sakulflee" ];
    })


    (import ../../modules/services/wireguard.nix {
      address = [ "100.64.0.2/32" ];
      allowedIPs = [
        "192.168.178.0/24"
        "100.64.0.0/10"
      ];
    })

    ../../modules/services/openvpn.nix
  ];
  # Hostname
  networking.hostName = "Dendra";
}
