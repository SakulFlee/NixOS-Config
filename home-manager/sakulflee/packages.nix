{ pkgs, ... }: {
  home.packages = with pkgs; [
    htop
    btop
    lmstudio
    nnn
    discord
    floorp-bin
    vlc
  ];
}
