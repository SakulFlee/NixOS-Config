{ pkgs, ... }: {
  # ZEN Kernel for gaming
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.sortKey = "NixOS (Gaming/ZEN)";

  specialisation = {
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
