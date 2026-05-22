{ pkgs, ... }: {
  users.users.root = {
    # Password should be set via 'passwd' command for security
  };

  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ../home-manager/shared/hyprland.nix
      ../home-manager/shared/waybar.nix
    ];
    home.stateVersion = "25.11";
  };
}
