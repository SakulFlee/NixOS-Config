{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # Managed by UWSM!
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "swww-daemon"
        "hyprpolkitagent"
      ];

      bind = [
        "SUPER, RETURN, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER, M, exit"
        "SUPER, R, exec, hyprlauncher"
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
