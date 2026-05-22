{ pkgs, ... }: {
  users.users.root = {
    # Root is the superuser by default
  };

  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ../../home-manager/shared/hyprland.nix
      ../../home-manager/shared/waybar.nix
    ];
    home.stateVersion = "25.11";
  };
}
