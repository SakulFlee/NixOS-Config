{ pkgs, ... }: {
  users.users.sakulflee = {
    description = "SakulFlee";

    initialPassword = "nixos";

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
      ../home-manager/sakulflee/_defaults.nix
    ];

    home.file.".config/nvim" = {
      source = ../neovim-config;
      recursive = true;
    };

    home.stateVersion = "25.11";
  };
}
