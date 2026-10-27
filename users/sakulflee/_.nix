{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.installPackages = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install user packages (mostly GUI, requires GUI) for sakulflee";
  };

  config = {
    users.users.sakulflee = {
      description = "SakulFlee";

      initialPassword = "nixos";

      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        # SakulFlee's main key (matches the sops-managed private key)
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImnWUykSX10iZYDF4g0bqy/uOXppRwWodtmg3iYBfBS sakulflee@nixos"
        # Tablet Termux key (OpenCode over SSH)
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIssQBMMbluui0iK6IB/L0C0f2R79ZUk280OHRe1mNBW u0_a510@localhost"
      ];

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
        # Access to NAS media shares
        "media"
        # Docker
        "docker"
      ];

      shell = pkgs.zsh;
    };

    home-manager.users.sakulflee = {
      imports = [
        ../../modules/home-manager/_.nix
        ./ssh.nix
        ./git.nix
        ./gpg.nix
        ./incus.nix
        ./zsh.nix
      ]
      ++ (
        if config.custom.installPackages then
          [
            ./configs/_.nix
          ]
        else
          [ ]
      );

      home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      home.stateVersion = "25.11";
    };
  };
}
