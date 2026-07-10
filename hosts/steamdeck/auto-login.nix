{ lib, ... }: {
  # Auto-login to Steam Big Picture.
  # SDDM's Relogin defaults to false, so exiting Steam drops you at the
  # greeter where you can select "Plasma" and enter your password for
  # desktop mode. Next boot re-triggers auto-login.
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "sakulflee";
    };
    defaultSession = lib.mkForce "steam";
    sddm = {
      wayland.compositor = "kwin";
      settings.General.IdleTimeout = 0;
    };
  };
}
