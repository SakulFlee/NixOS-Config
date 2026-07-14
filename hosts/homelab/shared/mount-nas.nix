{ config, pkgs, lib, ... }:
let
  shares = [
    "personal_folder"
    "Doujin"
    "Hentai"
    "Movies"
    "Music"
    "NSFW"
    "PBS"
    "qBittorrent"
    "Shows"
    "HomeLab-Backups"
  ];

  nasServer = "//192.168.178.250";

  makeMount = shareName: {
    name = "/mnt/nas/${shareName}";
    value = lib.mkForce {
      device = "${nasServer}/${shareName}";
      fsType = "cifs";
      options = [
        "credentials=/run/secrets/smb_credentials"
        "uid=1000"
        "gid=100"
        "file_mode=0664"
        "dir_mode=0775"
        "_netdev"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60"
        "x-systemd.requires=sops-install-secrets.service"
      ];
    };
  };
in {
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems = builtins.listToAttrs (map makeMount shares);
}
