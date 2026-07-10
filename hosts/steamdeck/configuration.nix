{ lib, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/_.nix
    ../../shared/nix/_.nix
    inputs.jovian.nixosModules.jovian
  ];

  # Apply Jovian overlay (provides gamescope-session, steamos-manager, etc.)
  # Then fix gamescope: Jovian overrides src/version to 3.16.24 but inherits
  # stale patches and substituteInPlace calls from nixpkgs-26.05 that don't
  # apply to that version.
  nixpkgs.overlays = [
    inputs.jovian.overlays.default
    (final: prev: {
      gamescope = prev.gamescope.overrideAttrs (_: {
        patches = [];
        postPatch = "";
      });
    })
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
