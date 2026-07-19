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

  services.logind.settings.Login.HandlePowerKey = "ignore";

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
    (pkgs.writeShellScriptBin "steamos-session-select" ''
      case "''${1:-}" in
        desktop|plasma*|gnome*|xfce*)
          # Switch to desktop: terminate session to return to SDDM
          ;;
      esac
      if [ -n "$XDG_SESSION_ID" ]; then
        exec loginctl terminate-session "$XDG_SESSION_ID"
      else
        exec loginctl terminate-user "$USER"
      fi
    '')
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
