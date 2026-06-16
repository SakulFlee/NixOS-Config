{ pkgs, ... }: {
  # ZEN Kernel for gaming
  boot.kernelPackages = pkgs.linuxPackages_latest_zen;
  boot.loader.systemd-boot.description = "NixOS (Gaming/ZEN)";

  specialisation = {
    lts.configuration = {
      system.nixos.tags = [ "LTS" ];
      boot.kernelPackages = pkgs.linuxPackages; # Defaults to latest LTS
    };

    gaming.configuration = {
      system.nixos.tags = [ "Latest" ];
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
  };
}
