{ lib, pkgs, ... }: {
  # Default kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  specialisation = {
    lts.configuration = {
      system.nixos.tags = [ "Gaming" ];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen; # ZEN for gaming
    };

    lts.configuration = {
      system.nixos.tags = [ "LTS" ];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages; # Defaults to latest LTS
    };

    gaming.configuration = {
      system.nixos.tags = [ "Latest" ];
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    };
  };
}
