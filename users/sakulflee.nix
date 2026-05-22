{ pkgs, ... }: {
  users.users.sakulflee = {
    description = "SakulFlee";

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
      ../home-manager/sakulflee/packages.nix
      ../home-manager/sakulflee/programs.nix
      ../home-manager/shared/hyprland.nix
      ../home-manager/shared/waybar.nix
    ];

    home.stateVersion = "25.11";
  };
}
