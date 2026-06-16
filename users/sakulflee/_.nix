{ pkgs, unstable, ... }: {
  users.users.sakulflee = {
    description = "SakulFlee";

    initialPassword = "nixos";

    isNormalUser = true;
    
    extraGroups = [ 
      # To be able to use network manager (KDE Networking)
      "networkmanager"
      # Sudo privileges
      "wheel"
      # Access to GPU (also required by Sunshine)
      "video" 
      "render"
      # Universal inputs (gamepads, touch, mouse, keyboard, etc.; Also required for Sunshine!)
      "uinput"
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
      ./kitty.nix
      ./zsh.nix
    ];

    home.file.".config/nvim" = {
      source = ../../neovim-config;
      recursive = true;
    };

    home.stateVersion = "25.11";
  };
}
