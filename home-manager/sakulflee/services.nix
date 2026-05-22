{ pkgs, ... }: {
  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Wayland Sunset (Night Light)";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -l 51.196082 -L 6.437104";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
