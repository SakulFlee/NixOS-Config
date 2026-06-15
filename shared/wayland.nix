{ ... }:
{
  # Wayland is enabled by disabling x11/xserver
  services.xserver.enable = false;

    # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
