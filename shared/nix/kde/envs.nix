{ pkgs, ... }: {
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.systemd}/bin/systemctl --user import-environment DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY WAYLAND_DISPLAY
  '';
}
