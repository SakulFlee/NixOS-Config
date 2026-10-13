{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [ 
        pkgs.neovim
    ];
}
