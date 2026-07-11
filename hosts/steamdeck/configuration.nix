{ config, pkgs, inputs, ... }: {
  imports = [
    inputs.jovian.nixosModules.jovian
    ./hardware.nix
    ../../shared/nix-hardware/firmware.nix
    ../../shared/nix/boot-loader.nix
    ../../shared/nix/experimental-features.nix
    ../../shared/nix/fonts.nix
    ../../shared/nix/gpg.nix
    ../../shared/nix/home-manager.nix
    # ../../shared/nix/kde DIR
    ../../shared/nix/kernel.nix
    ../../shared/nix/locale.nix
    ../../shared/nix/mount-nas.nix
    # ../../shared/nix/_.nix
    ../../shared/nix/nixos-config-rebuilder.nix
    ../../shared/nix/nixpkgs-unfree.nix
    ../../shared/nix/printing.nix
    # ../../shared/nix/services DIR
    ../../shared/nix/sops.nix
    ../../shared/nix/ssh.nix
    # ../../shared/nix/steam.nix
    ../../shared/nix/system-packages.nix
    ../../shared/nix/system-state.nix
    # ../../shared/nix/wayland.nix
    ../../shared/nix/wireguard.nix
    ../../shared/nix/zram.nix
    ../../shared/nix/zsh.nix
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
