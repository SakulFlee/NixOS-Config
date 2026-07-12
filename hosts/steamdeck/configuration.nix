{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    inputs.jovian.nixosModules.jovian
    ../../shared/common/_.nix
    ../../users/_.nix
  ];

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
