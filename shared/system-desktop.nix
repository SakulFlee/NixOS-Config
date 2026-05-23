{ pkgs, ...}:
{
  # Wayland
  services.xserver.enable = false;

  # KDE & SDDM
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Touchpad
  services.libinput.enable = true;

  # Printing
  services.printing.enable = true;
}
