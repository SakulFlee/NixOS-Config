{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
  ];

  # Hostname
  networking.hostName = "Cindry";
}

