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

  # Override ZEN kernel with Jovian's Valve kernel (has Steam Deck display patches)
  # Regular priority (100) beats lib.mkDefault (1000) in kernel.nix, but specialisations'
  # lib.mkForce still overrides this for their own kernel selections.
  boot.kernelPackages = pkgs.linuxPackages_jovian;

  # Enable Steam Deck device support (panel driver, bridge, DTM TA, etc.)
  jovian.devices.steamdeck.enable = true;

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
