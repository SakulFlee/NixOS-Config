{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../shared/common/_homelab.nix
    ../../users/_.nix
  ];
  custom.installPackages = false;

  # Hostname
  networking.hostName = "HomeLab";
}

