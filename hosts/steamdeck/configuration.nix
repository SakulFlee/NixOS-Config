{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware.nix
    ../../shared/common/_.nix
    ../../users/_.nix
  ];

  nixpkgs.overlays = [ inputs.jovian.overlays.default ];

  networking.hostName = "SteamDeck";

  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sakulflee";
    };
    sddm.autoLogin.relogin = true;
    defaultSession = "gamescope-wayland";
    sessionPackages = [ pkgs.gamescope-session ];
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";

  security.wrappers.gamescope = {
    owner = "root";
    group = "root";
    source = "${lib.getBin pkgs.gamescope}/bin/gamescope";
    capabilities = "cap_sys_nice+pie";
  };

  systemd.packages = [
    pkgs.gamescope-session
    pkgs.powerbuttond
    pkgs.steamos-manager
  ];

  services.dbus.packages = [ pkgs.steamos-manager ];
  services.udev.packages = [ pkgs.powerbuttond ];

  systemd.user.services.steamos-manager = {
    wantedBy = [ "gamescope-session.service" ];
  };

  systemd.user.services.steamos-powerbuttond = {
    wantedBy = [ "gamescope-session.service" ];
  };

  systemd.services.steamos-manager = {
    wantedBy = [ "multi-user.target" ];
  };

  systemd.user.services.jovian-setup-desktop-session = {
    wants = [ "steamos-manager.service" ];
    after = [ "steamos-manager.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.steamos-manager}/bin/steamosctl set-default-desktop-session plasma.desktop";
    };
    wantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.steamos-manager-session-cleanup = {
    wantedBy = [ "graphical-session.target" ];
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
