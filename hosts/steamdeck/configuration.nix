{ lib, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    inputs.jovian.nixosModules.jovian
  ];

  # Hostname
  networking.hostName = "SteamDeck";

  # Jovian Steam Deck integration
  jovian.steam = {
    enable = true;
    # Boot directly into Steam Big Picture via gamescope
    autoStart = true;
    user = "sakulflee";
    # "Switch to Desktop" in Steam goes to Plasma; logout returns to Gaming Mode
    desktopSession = "plasma";
  };
}
