{ lib, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    inputs.jovian.nixosModules.jovian
  ];

  # Hostname
  networking.hostName = "SteamDeck";

  # Silence version mismatch warnings (home-manager/nixvim on 26.05, pkgs on 26.11)
  home-manager.users.sakulflee.home.enableNixpkgsReleaseCheck = false;
  home-manager.users.sakulflee.programs.nixvim.version.enableNixpkgsReleaseCheck = false;

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
