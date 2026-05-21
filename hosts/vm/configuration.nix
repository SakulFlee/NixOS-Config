{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/sakulflee.nix
    ../../shared/_defaults.nix
    ../../shared/display_server/wayland.nix
    ../../shared/networkmanager.nix
    ../../shared/audio/pulsewire.nix
    ../../shared/ssh.nix
    ../../shared/gpg.nix
    ../../shared/qemu_guest.nix
  ];

  # Hostname
  networking.hostName = "VM";

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = false;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Auto-Login
  services.displayManager.autoLogin = {
    enable = true;
    user = "sakulflee";
  };
}

