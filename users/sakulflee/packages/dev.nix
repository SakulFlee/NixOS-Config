{ pkgs, ... }: {
  home.packages = with pkgs; [
    rustup
    neovim
    git
    wl-clipboard
  ];
}

