{ pkgs, ... }: {
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession = {
      enable = true;
      # Steam Deck panel is natively 800x1280 (portrait).
      # Rotate 90° left for proper landscape display.
      args = [ "--force-orientation" "left" ];
    };
    protontricks.enable = true;
  };
}
