{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/sakulflee.nix
    ../../shared/_defaults.nix
    ../../shared/display_server/wayland.nix
    ../../shared/desktop_environment/hyprland.nix
    ../../shared/networkmanager.nix
    ../../shared/audio/pulsewire.nix
    ../../shared/ssh.nix
    ../../shared/gpg.nix
    ../../shared/qemu_guest.nix
    ../../shared/experimental.nix
  ];

  # Hostname
  networking.hostName = "VM";

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = false;

  # SDDM
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
    };

    defaultSession = "hyprland-uwsm";
  };
}

