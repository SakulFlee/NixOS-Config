{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./boot.nix
    ./gamescope-and-steam.nix
    ../../users/sakulflee.nix
    ../../shared/_defaults.nix
    ../../shared/syncthing.nix
    ../../shared/steam.nix
    ../../shared/desktop-gnome.nix
  ];

  # Hostname
  networking.hostName = "SteamDeck";

  # AutoLogin
  services.displayManager.autoLogin = {
    enable = true;
    user = "sakulflee";
  };
}

