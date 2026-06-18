{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wl-clipboard
  ];
}

