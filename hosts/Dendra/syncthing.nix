{ config, pkgs, ... }: {
  services.syncthing = {
    enable = true;
    user = "sakulflee";
    dataDir = "/mnt/ssd/";
    configDir = "/home/sakulflee/.config/syncthing";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        HomeLab = {
          id = "WQULGP6-QFZWHOS-CNVGE7L-VYOUIRB-PRIIDUM-WIB4G3E-3RHXMA5-MLUA3AA";
        };
        Phone = {
          id = "XEHPA3V-IRL2YWY-NWZLQBD-BGQPA6M-6YMLMJ6-TWTLL4S-DQ4SWEH-LOCV2QU";
        };
        Tablet = {
          id = "SNYIG75-W45Q76Z-WG75WFD-CYHWXW4-ZYAHQVX-2XY63I4-BIMXXRX-O2BI3Q4";
        };
      };
      folders = {
        "/mnt/ssd/Personal/" = {
          id = "personal";
          devices = [ "HomeLab" ];
        };       
        "/mnt/ssd/Replicated: hytale-backups/" = {
          id = "replicated-hytale-backups";
          devices = [ "HomeLab" ];
        };       
        "/mnt/ssd/Replicated: minecraft-backups/" = {
          id = "replicated-minecraft-backups";
          devices = [ "HomeLab" ];
        };       
        "/mnt/ssd/Replicated: paperless-media/" = {
          id = "replicated-paperless-media";
          devices = [ "HomeLab" ];
        };
      };
    };
  };

  # Port 8384/TCP: WebUI
  # Port 22000/TCP: TCP based sync protocol traffic
  networking.firewall.allowedTCPPorts = [ 22000 8384 ];

  # Port 22000/UDP: QUIC based sync protocol traffic
  # Port 21027/UDP: for discovery broadcasts on IPv4 and multicasts on IPv6
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
