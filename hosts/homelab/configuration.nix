{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./kernel.nix
    ./services/_.nix
    ./shared/_.nix
    ../../shared/common/_homelab.nix
    ../../users/_.nix
  ];
  custom.installPackages = false;

  # Hostname
  networking.hostName = "HomeLab";
}