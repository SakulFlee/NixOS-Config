{ pkgs, ... }: {
  home.packages = with pkgs; [
    freefilesync
    obsidian
  ];
}
