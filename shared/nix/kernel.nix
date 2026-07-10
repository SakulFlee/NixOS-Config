{ lib, pkgs, ... }: {
  # Default kernel is gaming focused (ZEN)
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  specialisation = {
    latest.configuration = {
      system.nixos.tags = [ "Latest" ];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    };

    lts.configuration = {
      system.nixos.tags = [ "LTS" ];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages; # Defaults to latest LTS
    };
  };
}
