{ pkgs, ... }: {
  home.packages = with pkgs; [
    freefilesync
  ];
}
