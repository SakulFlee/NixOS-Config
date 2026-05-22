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
      ./sakulflee/packages.nix
      ./sakulflee/programs.nix
      ./sakulflee/hyprland.nix
    ];

    home.stateVersion = "25.11";
  };
}
