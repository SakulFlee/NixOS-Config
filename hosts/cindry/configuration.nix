{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/_.nix
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

