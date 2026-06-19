{ pkgs, ... }: {
  home.packages = with pkgs; [
    brave
    kdePackages.kmail
    kdePackages.kmail-account-wizard
  ];
}
