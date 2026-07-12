{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    
    ../../users/_.nix
  ];

  # Hostname
  networking.hostName = "HomeLab";
}

