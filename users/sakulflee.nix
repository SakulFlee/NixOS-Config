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
}
