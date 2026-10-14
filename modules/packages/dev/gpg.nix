{ pkgs, ... }: {
    programs.gpg.enable = true;
    environment.systemPackages = with pkgs; [ 
        gnupg
    ];
}
