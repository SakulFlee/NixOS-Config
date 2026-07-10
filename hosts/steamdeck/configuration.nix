{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./auto-login.nix
    ./steam.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    ./screen-rotation.nix
  ];

  # Hostname
  networking.hostName = "SteamDeck";
}
