{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Managed by UWSM!
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "swww-daemon"
      ];

      bind = [
        "SUPER, RETURN, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER, M, exit"
      ];

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
        };
      };

      input = {
        kb_layout = "de";
        kb_variant = "";
        follow_mouse = 1;
        sensitivity = 0;
      };
    };
  };
}
