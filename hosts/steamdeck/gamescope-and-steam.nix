{ ... }: {
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  services.displayManager.defaultSession = "steam";
}
