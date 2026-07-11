{ pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    inputs.jovian.nixosModules.jovian
  ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "SteamDeck";

  jovian.steam.user = "sakulflee";
}
