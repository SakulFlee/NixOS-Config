{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./kernel.nix
    ../../shared/common/_homelab.nix
    ../../users/_.nix
  ];
  custom.installPackages = false;

  # Hostname
  networking.hostName = "HomeLab";
}

