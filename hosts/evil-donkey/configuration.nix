{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    ../../shared/optionals/openrgb.nix
    ./screen-rotation.nix
  ];

  # Hostname
  networking.hostName = "Evil-Donkey";
}

