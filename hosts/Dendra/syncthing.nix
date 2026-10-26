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
          id = "OKWFZ4I-IQBJHO5-LKPGDYY-E7OMWIW-KHN7H4E-4WJWP6F-Q64BLAU-KWSR6QJ";
        };
        Tablet = {
          id = "SNYIG75-W45Q76Z-WG75WFD-CYHWXW4-ZYAHQVX-2XY63I4-BIMXXRX-O2BI3Q4";
        };
      };
      folders = {
        "/mnt/ssd/Personal/" = {
          id = "personal";
          devices = [
            "HomeLab"
            "Tablet"
            "Phone"
          ];
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
}
