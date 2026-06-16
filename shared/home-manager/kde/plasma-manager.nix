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

    # Custom Folder View for your Synced Desktop Folder
    desktop = {
      widgets = [
        {
          name = "org.kde.plasma.folder";
          position = {
            horizontal = 100;
            vertical = 100;
          };
          size = {
            width = 20;
            height = 20;
          };
          config = {
            General = {
              url = "file:///home/sakulflee/Sync/Desktop";
              sortMode = "2";    # Sort by Date
              alignment = "1";   # Icons on the Right
              arrangement = "1"; # Organize in Rows
            };
          };
        }
      ];
    };

    panels = [
      # Top Panel: App menu, system tray, launcher, etc.
      {
        location = "top";
        height = 44;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.pager"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }

      # Bottom Panel: Dock
      {
        location = "bottom";
        height = 44;
        widgets = [
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General = {
                launchers = [
                  "preferred://filemanager"
                  "preferred://browser"
                  "applications:discord.desktop"
                  "applications:brave-browser.desktop"
                  "applications:obsidian.desktop"
                ];
              };
            };
          }
        ];
      }
    ];
  };
}

