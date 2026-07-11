{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.jovian.nixosModules.jovian
    ./hardware.nix
    ../../shared/nix-hardware/_.nix
    ../../shared/nix/_.nix
    ../../users/_.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  networking.hostName = "SteamDeck";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Add Plasma as desktop session for "Switch to Desktop"
  services.desktopManager.plasma6.enable = true;

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
