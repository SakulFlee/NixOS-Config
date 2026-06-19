{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
  ];

  # Hostname
  networking.hostName = "Evil-Donkey";

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

