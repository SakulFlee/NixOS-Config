{ lib, pkgs, ... }: {
  imports = [
    ../../modules/common/hardware.nix
    ../../modules/common/screen-rotation.nix
    ../../users/_.nix
    ../../modules/services/vpn.nix
    ../../modules/common/_.nix
    ../../modules/common/common/_.nix
    ../../modules/common/optionals/openrgb.nix
    ../../modules/common/optionals/vbox.nix
  ];
  # Hostname
  networking.hostName = "Dendra";
}
