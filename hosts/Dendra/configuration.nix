{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./syncthing.nix
    ../../users/_.nix
#     ../../modules/services/vpn.nix
    ../../modules/common/_.nix
#    ../../modules/common/optionals/openrgb.nix
#    ../../modules/common/optionals/vbox.nix
    ../../modules/games/_.nix

    (import ../../modules/common/wireguard.nix {
      address = [ "100.64.0.2/32" ];
      allowedIPs = [ "192.168.178.0/24" "100.64.0.0/10" ];
      privateKey = "gLYRXmnfOVfDmeLEkPq4XVVkKZ56obcarG0kFFNcrV4=";
    })

    (import ../../modules/services/hermes-agent.nix {
      users = [ "sakulflee" ];
    })
  ];
  # Hostname
  networking.hostName = "Dendra";
}
