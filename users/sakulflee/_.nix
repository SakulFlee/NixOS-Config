{ config, lib, pkgs, unstable, ... }: {
  options.custom.installPackages = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install user packages (mostly GUI, requires GUI) for sakulflee";
  };

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

  home-manager.users.sakulflee = {
    imports = [
      ../../shared/home-manager/_.nix
      ./git.nix
      ./gpg.nix
      ./zsh.nix
    ] ++ (if config.custom.installPackages then [ 
      ./packages/_.nix
      ./configs/_.nix
    ] else [ ]);

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    home.stateVersion = "25.11";
  };
}
