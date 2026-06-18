{ pkgs, ... }: {
  home.packages = with pkgs; [
    obsidian
    kdePackages.filelight
    pxder
  ];
}
