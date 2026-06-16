{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };

  home.packages = with pkgs; [
    protonup-qt
  ];
}
