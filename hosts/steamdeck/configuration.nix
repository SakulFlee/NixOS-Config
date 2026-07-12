{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.jovian.nixosModules.jovian
    ./hardware.nix
    # ../../shared/nix/_.nix
    ../../shared/boot-loader.nix
    ../../shared/experimental-features.nix
    ../../shared/fonts.nix
    ../../shared/gpg.nix
    ../../shared/home-manager.nix
    # ../../shared/kde
    ../../shared/kernel.nix
    ../../shared/locale.nix
    ../../shared/mount-nas.nix
    # ../../shared/_.nix
    ../../shared/nixos-config-rebuilder.nix
    ../../shared/nixpkgs-unfree.nix
    ../../shared/printing.nix
    # ../../shared/services
    ../../shared/sops.nix
    ../../shared/ssh.nix
    ../../shared/steam.nix
    ../../shared/system-packages.nix
    ../../shared/system-state.nix
    ../../shared/wayland.nix
    ../../shared/wireguard.nix
    ../../shared/zram.nix
    ../../shared/zsh.nix
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
