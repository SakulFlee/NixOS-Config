{ pkgs, ... }: {
  home.packages = with pkgs; [
    rustup
    git
    wl-clipboard
  ];
}

