{ ... }: {
  # Plasma associates panels with a numeric screen index and intentionally
  # does not move them when displays are added or removed. The panel layout
  # script from plasma-manager only runs when its generated JS changes, so a
  # panel that drifted to another monitor stays there across logins.
  #
  # Reassert the panel screen on every login. Screen 0 is KDE's primary
  # screen; if the primary output is off, it is the remaining output.
  programs.plasma.startup.desktopScript."pin-panels" = {
    priority = 4;
    runAlways = true;

    text = ''
      // Keep all panels on KDE's primary screen.
      panels().forEach(function (panel) {
        panel.screen = 0;
      });
    '';
  };
}
