{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.jovian.nixosModules.jovian
    ./hardware.nix
    ../../shared/nix-hardware/_.nix
    ../../shared/nix/_.nix
    ../../users/_.nix
  ];

  boot.loader.systemd-boot.enable = true;
  networking.hostName = "SteamDeck";

  jovian = {
    devices.steamdeck.enable = true;
    steam = {
      enable = true;
      autoStart = true;
      user = "sakulflee";
      desktopSession = "plasma";
    };
  };
}
