{ pkgs, ...}:
{
  imports = [
    # KiTTY is required by Hyprland!
    ../packages/kitty.nix
  ];

  programs.hyprland = {
    enable = true;

    # Universal Wayland Session Manager
    withUWSM = true;

    # Support xWayland
    xwayland.enable = true;
  };

  # Login Manager
  programs.regreet = {
    enable = true;
  };

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
}
