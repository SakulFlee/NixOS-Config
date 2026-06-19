{ pkgs, ... }: {
  home.packages = with pkgs; [
    brave
    kdePackages.kmail
  ];
}
