{ pkgs, ... }: {
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession = {
      enable = true;
      # Steam Deck panel is natively 800x1280 (portrait).
      # Rotate 90° right for proper landscape display.
      args = [ "--force-orientation" "right" ];
    };
    protontricks.enable = true;
  };
}
