# Use Home-Manger! 
# Do not use directly in NixOS.
{ inputs, pkgs, ... }: {
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  programs.plasma = {
    enable = true;
    workspace = {
      clickToOpen = true;
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Next/contents/images/5120x2880.png";
    };

    panels = [
      # Configure your main taskbar panel declaratively!
      {
        location = "bottom";
        height = 44;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
