{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    inputs.jovian.nixosModules.jovian
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  networking.hostName = "SteamDeck";

  users.users.sakulflee = {
    isNormalUser = true;
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;

  jovian = {
    devices.steamdeck.enable = true;
    steam = {
      enable = true;
      autoStart = true;
      user = "sakulflee";
      desktopSession = "gamescope-wayland";
    };
  };
}
