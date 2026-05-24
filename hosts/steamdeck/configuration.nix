{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./boot.nix
    ../../users/sakulflee.nix
    ../../shared/_defaults.nix
    ../../shared/syncthing.nix
    ../../shared/steam.nix
    ../../shared/desktop-gnome.nix
  ];

  # Hostname
  networking.hostName = "SteamDeck";

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

