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
      # i2c support
      "i2c"
    ];

    shell = pkgs.zsh;
  };

  home-manager.users.sakulflee = { pkgs, ...}: {
    imports = [
      ../../shared/home-manager/_.nix
      ./configs/_.nix
      ./packages/_.nix
      ./git.nix
      ./gpg.nix
      ./kitty.nix
      ./zsh.nix
    ];

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    home.stateVersion = "25.11";
  };
}
