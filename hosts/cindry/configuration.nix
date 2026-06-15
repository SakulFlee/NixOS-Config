{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/sakulflee/_.nix
    ../../shared/_defaults.nix
    ../../shared/syncthing.nix
    ../../shared/steam.nix
    ../../shared/nas.nix
    ../../packages/sops.nix
    ../../packages/files.nix
    ../../packages/development.nix
  ];

  # Hostname
  networking.hostName = "Cindry";

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

