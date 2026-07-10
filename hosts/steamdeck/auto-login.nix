{ pkgs, ... }: {
  # Auto-login to KDE Plasma (not the Steam session).
  # Steam/gamescope runs nested within KWin, so there's no DRM master
  # handoff issue — KWin stays in control of the display.
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sakulflee";
    };
    defaultSession = "plasma";
    sddm.settings.General.IdleTimeout = 0;
  };

  # Auto-start Steam Big Picture within Plasma via gamescope
  systemd.user.services.steam-bigpicture = {
    description = "Steam Big Picture via Gamescope";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "plasma-workspace.target" ];
    
    script = ''
      ${pkgs.gamescope}/bin/gamescope \
        --steam \
        --force-orientation right \
        -- steam -tenfoot -pipewire-dmabuf
    '';
  };
}
