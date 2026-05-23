{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/sakulflee.nix
    ../../users/root.nix
    ../../shared/_defaults.nix
    ../../shared/syncthing.nix
  ];

  # Hostname
  networking.hostName = "Cindry";

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-uuid/fad2025e-e33e-45a5-af9a-8338cca5ee97";
  boot.loader.grub.useOSProber = false;

  # SDDM
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
    };

    defaultSession = "plasma";
  };
}

