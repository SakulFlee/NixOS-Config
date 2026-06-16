{ pkgs, unstable, ... }: {
  users.users.sakulflee = {
    description = "SakulFlee";

    initialPassword = "nixos";

    isNormalUser = true;
    
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "video" 
      "render"
    ];

    shell = pkgs.zsh;

    packages = with pkgs; [
      faugus-launcher
    ];
  };

  home-manager.users.sakulflee = { pkgs, ...}: {
    imports = [
      ../../shared/home-manager/_.nix
      ./packages/_.nix
      ./git.nix
      ./gpg.nix
    ];

    home.file.".config/nvim" = {
      source = ../../neovim-config;
      recursive = true;
    };

    home.stateVersion = "25.11";
  };
}
