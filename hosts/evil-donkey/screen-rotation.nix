{ pkgs, config, lib, ... }:

let
  # Custom weston.ini for SDDM that includes DP-1 180° rotation
  # SDDM generates its own weston.ini internally, so we need to override
  # the compositor command to use one that includes the output rotation.
  sddmWestonIni = pkgs.writeText "weston-sddm-rotated.ini" ''
    [libinput]
    enable-tap=true
    [keyboard]
    keymap_layout=${config.services.xserver.xkb.layout}
    [output]
    name=DP-1
    transform=180
  '';
in
{
  # 1. TTY / Console — rotate framebuffer 180°
  boot.kernelParams = [ "fbcon=rotate:2" ];

  # 2. SDDM (login screen) — rotate via weston compositor override
  services.displayManager.sddm.settings = {
    Wayland.CompositorCommand = ''
      ${pkgs.weston}/bin/weston --shell=kiosk -c ${sddmWestonIni}
    '';
  };

  # 3. KDE Plasma — rotate via kscreen-doctor on graphical session start
  systemd.user.services.rotate-kde = {
    description = "Rotate KDE Plasma display by 180 degrees";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    script = ''
      ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-1.rotation.inverted
    '';
  };
}
