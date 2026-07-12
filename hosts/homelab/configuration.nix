{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    
    ../../users/_.nix
  ];
  custom.installPackages = false;

  # Hostname
  networking.hostName = "HomeLab";
}

