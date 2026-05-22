{ pkgs, ... }: {
  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Wayland Sunset (Night Light)";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -l 51.15 -L 6.5";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
