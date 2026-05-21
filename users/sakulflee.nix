{ pkgs, ... }: {
  users.users.sakulflee = {
    isNormalUser = true;
    description = "SakulFlee";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
    ];

    packages = with pkgs; [
      # ...
    ];
  };
}
