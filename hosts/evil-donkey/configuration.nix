{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    ../../shared/nix/kde/sddm-rotation.nix
  ];

  # Hostname
  networking.hostName = "Evil-Donkey";
}

