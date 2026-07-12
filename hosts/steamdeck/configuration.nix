{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.jovian.nixosModules.jovian
    ./hardware.nix
    # ../../shared/nix/_.nix
    ../../shared/nix/boot-loader.nix
    ../../shared/nix/experimental-features.nix
    ../../shared/nix/fonts.nix
    ../../shared/nix/gpg.nix
    ../../shared/nix/home-manager.nix
    # ../../shared/nix/kde
    ../../shared/nix/kernel.nix
    ../../shared/nix/locale.nix
    ../../shared/nix/mount-nas.nix
    # ../../shared/nix/_.nix
    ../../shared/nix/nixos-config-rebuilder.nix
    ../../shared/nix/nixpkgs-unfree.nix
    ../../shared/nix/printing.nix
    ../../shared/nix/services/_.nix
    ../../shared/nix/sops.nix
    ../../shared/nix/ssh.nix
    ../../shared/nix/steam.nix
    ../../shared/nix/system-packages.nix
    ../../shared/nix/system-state.nix
    ../../shared/nix/wayland.nix
    ../../shared/nix/wireguard.nix
    ../../shared/nix/zram.nix
    ../../shared/nix/zsh.nix
    ../../users/_.nix
  ];

  networking.hostName = "SteamDeck";

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
