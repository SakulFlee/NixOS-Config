{
  imports = [
    # KiTTY is required by Hyprland!
    ../packages/kitty.nix
  ];

  programs.hyprland.enable = true;

  # Hint Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
