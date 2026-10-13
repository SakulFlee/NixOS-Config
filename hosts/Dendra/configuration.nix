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
  ];
  # Hostname
  networking.hostName = "Dendra";
}
