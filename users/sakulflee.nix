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
  };
}
