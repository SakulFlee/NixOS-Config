{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./auto-login.nix
    ./steam.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
  ];

  # Hostname
  networking.hostName = "SteamDeck";
}
