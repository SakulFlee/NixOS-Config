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
    ../../shared/nix/kde/_.nix
    ../../shared/nix/kernel.nix
    ../../shared/nix/locale.nix
    ../../shared/nix/mount-nas.nix
    # ../../shared/nix/_.nix
    ../../shared/nix/nixos-config-rebuilder.nix
    ../../shared/nix/nixpkgs-unfree.nix
    ../../shared/nix/printing.nix
    ../../shared/nix/sops.nix
    ../../shared/nix/ssh.nix
    # ../../shared/nix/steam.nix
    ../../shared/nix/system-packages.nix
    ../../shared/nix/system-state.nix
    ../../shared/nix/wayland.nix
    ../../shared/nix/wireguard.nix
    ../../shared/nix/zram.nix
    ../../shared/nix/zsh.nix
    ../../shared/nix/wheel.nix

    ../../shared/nix/services/avahi.nix
    ../../shared/nix/services/dbus.nix
    # # ../../shared/nix/services/flatpak.nix
    ../../shared/nix/services/llama-swap.nix
    ../../shared/nix/services/ollama.nix
    ../../shared/nix/services/openrgb.nix
    ../../shared/nix/services/open-webui.nix
    ../../shared/nix/services/sunshine.nix
    ../../shared/nix/services/syncthing.nix

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
