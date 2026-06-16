{ pkgs, ... }: {
  home.packages = with pkgs; [
    rustup
    neovim
    git
    curl
    wget
    zip
    unzip
    tar
  ];
}

