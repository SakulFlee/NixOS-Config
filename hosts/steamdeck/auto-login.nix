{ pkgs, lib, ... }:

let
  steamdeck-session = pkgs.writeShellScriptBin "steamdeck-session" ''
    set -e
    # Start gaming session. When Steam exits, launch SDDM for desktop mode.
    ${pkgs.gamescope}/bin/gamescope \
      --steam \
      --force-orientation right \
      -- steam -tenfoot -pipewire-dmabuf
    exec systemctl start display-manager
  '';

  # A script placed in KDE's menu to return to gaming mode
  return-to-gaming = pkgs.writeShellScriptBin "return-to-gaming" ''
    # Stops SDDM, which cycles back to the getty → steamdeck-session
    systemctl stop display-manager
  '';
in {
  # Boot directly into Steam Big Picture via getty auto-login on tty1.
  services.getty.autologinUser = lib.mkDefault "sakulflee";

  # Don't auto-start SDDM at boot
  systemd.services.display-manager.wantedBy = lib.mkForce [ ];

  # SDDM is available for on-demand desktop access
  services.displayManager.sddm = {
    enable = lib.mkDefault true;
    wayland.enable = true;
  };

  # Allow user to stop display-manager without password (for return-to-gaming)
  security.sudo.extraRules = [{
    users = [ "sakulflee" ];
    commands = [{
      command = "${pkgs.systemd}/bin/systemctl stop display-manager";
      options = [ "NOPASSWD" ];
    }];
  }];

  # Auto-start gamescope on tty1 login via .zprofile
  home-manager.users.sakulflee = {
    programs.zsh.profileExtra = ''
      # Auto-start Steam Big Picture on tty1 (no display server running yet)
      if [ "$(tty)" = "/dev/tty1" ] && [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
        exec ${steamdeck-session}/bin/steamdeck-session
      fi
    '';
  };

  environment.systemPackages = [ steamdeck-session return-to-gaming ];
}
