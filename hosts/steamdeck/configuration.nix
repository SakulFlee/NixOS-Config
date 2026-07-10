{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./boot.nix
    ./steam.nix
    ../../users/_.nix

    # Shared modules (same base as Cindry/Evil-Donkey, minus conflicting ones)
    ../../shared/nix/experimental-features.nix
    ../../shared/nix/nixpkgs-unfree.nix
    ../../shared/nix/locale.nix
    ../../shared/nix/audio.nix
    ../../shared/nix/bluetooth.nix
    ../../shared/nix/fonts.nix
    ../../shared/nix/kernel.nix
    ../../shared/nix/networking.nix
    ../../shared/nix/wayland.nix
    ../../shared/nix/ssh.nix
    ../../shared/nix/system-packages.nix
    ../../shared/nix/system-state.nix
    ../../shared/nix/gpg.nix
    ../../shared/nix/zsh.nix
    ../../shared/nix/home-manager.nix
    ../../shared/nix/sops.nix
    ../../shared/nix/zram.nix

    # KDE Plasma (same desktop as other hosts)
    ../../shared/nix/kde/_.nix

    # Services (Ollama, Sunshine, etc.)
    ../../shared/nix/services/_.nix

    # Not included from shared/nix/_.nix:
    #   boot-loader.nix   → handled by boot.nix (consoleMode=5 for Deck)
    #   steam.nix         → handled by ./steam.nix (gamescopeSession)
    #   touchpad.nix      → Deck has its own input handling
    #   printing.nix      → not needed
    #   mount-nas.nix     → not needed
    #   rclone-sync.nix   → not needed
    #   wireguard.nix     → not needed
    #   nixos-config-rebuilder.nix → opens kitty on rebuild, skip for Deck
  ];

  networking.hostName = "SteamDeck";

  # Auto-login to Steam Big Picture.
  # SDDM's Relogin defaults to false, so exiting Steam drops you at the
  # greeter where you can select "Plasma" and enter your password for
  # desktop mode. Next boot re-triggers auto-login.
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sakulflee";
    };
    defaultSession = lib.mkForce "steam";
  };
}
