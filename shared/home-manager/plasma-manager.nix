{ inputs, pkgs, ... }: {
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    enable = true;

    # Desktop Workspace Settings
    workspace = {
      clickItemTo = "open";
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "/usr/share/wallpapers/cachyos-wallpapers/PurpleFeathers.png";
    };

    # Native desktop containment showing ~/Sync/Desktop
    desktop = {
      widgets = [];

      icons = {
        arrangement = "topToBottom";
        alignment = "right";
        sorting.mode = "date";
      };
    };

    startup.desktopScript."set_desktop_url" = {
      text = ''
        var allDesktops = desktops();
        for (var i = 0; i < allDesktops.length; i++) {
            var d = allDesktops[i];
            d.currentConfigGroup = ["General"];
            d.writeConfig("url", "file:///home/sakulflee/Sync/Desktop");
        }
      '';
      priority = 3;
    };

    panels = [
      # Top Panel: App menu, system tray, launcher, etc.
      {
        location = "top";
        height = 28;

        floating = true;
        alignment = "center";
        lengthMode = "fill";
        hiding = "dodgewindows";

        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.pager"
          "org.kde.plasma.systemtray"
          {
            digitalClock = {
              time.format = "24h";
            };
          }
        ];
      }

      # Bottom Panel: Dock
      {
        location = "bottom";

        height = 44;
        floating = true;
        alignment = "center";
        lengthMode = "fit";
        hiding = "dodgewindows";

        widgets = [
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "preferred://filemanager"
                  "preferred://browser"
                  "applications:discord.desktop"
                  "applications:obsidian.desktop"
                ];
              };
            };
          }
        ];
      }
    ];

    shortcuts = {
      "services/kitty.desktop" = {
        "_launch" = "Ctrl+Alt+T";
      };
    };
  };
}

