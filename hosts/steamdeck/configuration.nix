{ config, pkgs, lib, ... }:
let
  gamescopeSession = pkgs.runCommand "gamescope-session" {
    providedSessions = [ "gamescope" ];
  } ''
    mkdir -p $out/share/wayland-sessions
    cat > $out/share/wayland-sessions/gamescope.desktop <<EOF
    [Desktop Entry]
    Name=Gamescope
    Comment=Steam Gaming Mode
    Exec=${pkgs.gamescope}/bin/gamescope -e -- ${pkgs.steam}/bin/steam -gamepadui
    Type=Application
    EOF
  '';

  steamosDbusExec = pkgs.writeShellScriptBin "steamos-dbus-exec" ''
    exec loginctl terminate-user "$(id -un)"
  '';

  steamosDbusService = pkgs.writeTextDir "share/dbus-1/services/com.steampowered.SteamOSManager1.service" ''
    [D-BUS Service]
    Name=com.steampowered.SteamOSManager1
    Exec=${steamosDbusExec}/bin/steamos-dbus-exec
  '';
in {
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
    sessionPackages = [ gamescopeSession ];
  };

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.dbus.packages = [ steamosDbusService ];

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

  home-manager.users.sakulflee = {
    programs.plasma.configFile."kwinrulesrc" = {
      "General" = { count = 1; };
      "1" = {
        Description = "Virtual Keyboard - prevent focus steal";
        windowclass = "maliit_keyboard";
        windowclassrule = 2;
        acceptfocus = "false";
        acceptfocusrule = 3;
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
