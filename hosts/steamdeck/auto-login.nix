{ lib, pkgs, ... }:

let
  steamdeck-session = pkgs.writeShellScriptBin "steamdeck-session" ''
    # Give SDDM's greeter compositor time to fully release DRM master
    # before gamescope tries to acquire it (avoids black screen on
    # Steam Deck's AMD Van Gogh GPU with auto-login)
    sleep 2
    exec ${pkgs.gamescope}/bin/gamescope \
      --steam \
      --force-orientation right \
      -- steam -tenfoot -pipewire-dmabuf
  '';

  steamdeck-desktop = pkgs.writeTextDir "share/wayland-sessions/steamdeck.desktop" ''
    [Desktop Entry]
    Name=SteamDeck
    Comment=Steam Big Picture via Gamescope
    Exec=${steamdeck-session}/bin/steamdeck-session
    Type=Application
  '';
in {
  # Auto-login to Steam Big Picture.
  # SDDM's Relogin defaults to false, so exiting Steam drops you at the
  # greeter where you can select "Plasma" and enter your password for
  # desktop mode. Next boot re-triggers auto-login.
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sakulflee";
    };
    defaultSession = lib.mkForce "steamdeck";
    sddm = {
      wayland.compositor = "kwin";
      settings.General.IdleTimeout = 0;
    };
  };

  environment.systemPackages = [ steamdeck-desktop ];
}
