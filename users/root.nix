{ pkgs, ... }: {
  users.users.root = {
    passwd = "sha512$6$/8CQ1JQEOl0F8Zta$j4lqp3Ep9X5xnnngZkJEkx2R5MFxWmWVzQq6wT7O7tQ1SK6VEn9wvRqy3u3du7yBl.yq1hFcDW0Pqxaa.Fc3T0";
  };

  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ../../home-manager/shared/hyprland.nix
      ../../home-manager/shared/waybar.nix
    ];
    home.stateVersion = "25.11";
  };
}
