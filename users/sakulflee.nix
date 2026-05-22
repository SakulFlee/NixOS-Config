{ pkgs, ... }: {
  users.users.sakulflee = {
    description = "SakulFlee";

    passwd = "sha512$6$/8CQ1JQEOl0F8Zta$j4lqp3Ep9X5xnnngZkJEkx2R5MFxWmWVzQq6wT7O7tQ1SK6VEn9wvRqy3u3du7yBl.yq1hFcDW0Pqxaa.Fc3T0";

    isNormalUser = true;
    
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
    ];

    shell = pkgs.zsh;

    packages = with pkgs; [
      # System-level packages for this user
    ];
  };

  home-manager.users.sakulflee = { pkgs, ...}: {
    imports = [
      ../../home-manager/sakulflee/packages.nix
      ../../home-manager/sakulflee/programs.nix
      ../../home-manager/shared/hyprland.nix
      ../../home-manager/shared/waybar.nix
    ];

    home.stateVersion = "25.11";
  };
}
