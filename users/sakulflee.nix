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
      # ...
    ];
  };

  home-manager.users.sakulflee = { pkgs, ...}: {
    home.stateVersion = "25.11";

    home.packages = [
      pkgs.htop
      pkgs.btop
    ];

    programs.git = {
      enable = true;
      userName = "@SakulFlee | Lukas Weber";
      userEmail = "dev@sakul-flee.de";
    };

    programs.zsh = {
      enable = true;
    };

    programs.waybar = {
      enable = true;
    };

    programs.kitty = {
      enable = true;
    };  

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ",preferred,auto,1";

	input = {
	  kb_layout = "de";
	  kb_variant = "";
	  # kb_options = "caps:escape"; # Maps caps lock to escape

	  follow_mouse = 1; # Focus follows mouse movement
	  sensitivity = 0;
	};
      };
    };
  };
}
