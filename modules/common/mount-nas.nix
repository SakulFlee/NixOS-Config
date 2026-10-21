{
  config,
  pkgs,
  inputs,
  ...
}:
let
  mediaGid = 972;

  shares = [
    "personal_folder"
    "Movies"
    "NSFW"
    "qBittorrent"
    "Shows"
  ];

  nasServer = "//192.168.178.250";

  makeMount = shareName: {
    name = "/mnt/nas/${shareName}";
    value = {
      device = "${nasServer}/${shareName}";
      fsType = "cifs";
      options = [
        # Crucial: Link to the decrypted runtime path provided by sops-nix
        "credentials=${config.sops.secrets.smb_credentials.path}"

        "uid=1000" # Maps files to your local user ID
        "gid=${toString mediaGid}" # Maps files to the 'media' group
        "file_mode=0664" # Gives you read/write access
        "dir_mode=0775" # Gives you read/write/execute on folders

        "_netdev" # Requires the network to be up
        "nofail" # Booting does not hang if the NAS is unreachable

        # Automount on-demand so booting doesn't hang if the NAS is asleep
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=60" # Unmounts after inactivity
      ];
    };
  };
in
{
  # Media group for NAS access (sonarr, radarr, jellyfin, sakulflee)
  users.groups.media = {
    gid = mediaGid;
  };

  # Install the SMB/CIFS client utilities
  environment.systemPackages = [
    pkgs.cifs-utils
    pkgs.samba # Provides smbclient for listing/browsing shares
  ];

  fileSystems = builtins.listToAttrs (map makeMount shares);
}
