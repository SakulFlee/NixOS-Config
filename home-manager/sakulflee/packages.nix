{ pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    htop
    btop
    nnn
    discord
    floorp-bin
    vlc
    keepassxc
    ollama
    unstable.lmstudio
  ];
}
