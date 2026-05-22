{ pkgs, ... }: {
  home.packages = with pkgs; [
    htop
    btop
    lmstudio
  ];
}
