{ pkgs, ... }: {
  home.packages = [
    pkgs.htop
    pkgs.btop
  ];
}
