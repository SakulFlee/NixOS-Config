{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    inputs.jovian.nixosModules.jovian
    ../../shared/common/_.nix
    ../../users/_.nix
  ];

  networking.hostName = "SteamDeck";

  jovian = {
    devices.steamdeck.enable = true;
    steamos.enableAutoMountUdevRules = false;
    steam = {
      enable = true;
      autoStart = true;
      user = "sakulflee";
      desktopSession = "plasma";
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
