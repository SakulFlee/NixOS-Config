{ pkgs, ...}:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
  };

  # Touchpad
  services.libinput.enable = true;

  # Printing
  services.printing.enable = true;
}
