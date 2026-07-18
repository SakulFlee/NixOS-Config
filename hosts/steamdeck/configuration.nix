{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware.nix
    ../../shared/common/_.nix
    ../../users/_.nix
  ];

  networking.hostName = "SteamDeck";

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sakulflee";
    };
    defaultSession = "gamescope";
    session = [{
      name = "gamescope";
      manage = "desktop";
      start = ''
        ${pkgs.gamescope}/bin/gamescope -e -- ${pkgs.steam}/bin/steam -gamepadui
      '';
    }];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  environment.systemPackages = with pkgs; [
    (makeDesktopItem {
      name = "steam-gaming-mode";
      exec = "${steam}/bin/steam -gamepadui";
      icon = "steam";
      desktopName = "Return to Gaming Mode";
      comment = "Switch to Steam Game Mode";
      categories = [ "Game" ];
    })
  ];

  # Prevent Maliit virtual keyboard from stealing focus on keypress
  home-manager.users.sakulflee = {
    programs.plasma.configFile."kwinrulesrc" = {
      "General" = { count = 1; };
      "1" = {
        Description = "Virtual Keyboard - prevent focus steal";
        windowclass = "maliit_keyboard";
        windowclassrule = 2;  # Force
        acceptfocus = "false";
        acceptfocusrule = 3;  # Force
      };
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.udisks2.filesystem-mount" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
}
