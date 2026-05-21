{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../../users/sakulflee.nix
    ../../shared/kernel.nix
    ../../shared/display_server/wayland.nix
    ../../shared/timezone.nix
    ../../shared/language.nix
    ../../shared/networkmanager.nix
    ../../shared/audio/pulsewire.nix
    ../../shared/packages/_default.nix
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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Auto-Login
  services.displayManager.autoLogin = {
    enable = true;
    user = "sakulflee";
  };
}

