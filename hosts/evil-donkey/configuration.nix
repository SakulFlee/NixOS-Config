{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    ./screen-rotation.nix
  ];

  # Hostname
  networking.hostName = "Evil-Donkey";
}

