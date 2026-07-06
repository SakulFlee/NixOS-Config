{ pkgs, ... }: {
  home.packages = with pkgs; [
    discord
    cinny-desktop
    element-desktop
  ];
}
