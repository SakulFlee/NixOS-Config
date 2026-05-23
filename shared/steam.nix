{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };

  environment.systemPackages = with pkgs; [
    protonup-qt
  ];
}
