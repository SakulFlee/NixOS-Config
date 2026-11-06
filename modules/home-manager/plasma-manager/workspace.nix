{ ... }: {
  programs.plasma.workspace = {
    clickItemTo = "select";
    lookAndFeel = "org.kde.breezedark.desktop";
    wallpaper = "/usr/share/wallpapers/cachyos-wallpapers/PurpleFeathers.png";
  };

  programs.plasma.input.keyboard = {
    layouts = [
      { layout = "de"; }
    ];
  };

  programs.plasma.configFile."kwinrc" = {
    # Screen-edge actions (Show Desktop, KRunner, ...). "None" is KWin's
    # canonical value for an unbound edge.
    "ElectricBorders" = {
      "BottomLeft" = "None";
      "BottomRight" = "None";
      "TopLeft" = "None";
      "TopRight" = "None";
    };

    # The Overview effect reserves its own electric borders, independent of
    # the screen-edge actions above. These are IntLists of KWin's ElectricBorder
    # enum, where 9 is ElectricNone, so a single 9 fully unbinds the hot corner.
    "Effect-overview" = {
      "BorderActivate" = "9";
      "GridBorderActivate" = "9";
      "TouchBorderActivate" = "9";
      "GridTouchBorderActivate" = "9";
    };
  };

  programs.plasma.startup.desktopScript."set_desktop_url" = {
    text = ''
      var allDesktops = desktops();
      for (var i = 0; i < allDesktops.length; i++) {
          var d = allDesktops[i];
          d.currentConfigGroup = ["General"];
          d.writeConfig("url", "file:///home/sakulflee/Desktop");
      }
    '';
    priority = 3;
  };
}
