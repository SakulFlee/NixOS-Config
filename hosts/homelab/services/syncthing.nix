{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;
  };

  networking.firewall.allowedTCPPorts = [ 22000 8384 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/syncthing" ];
  };
}
