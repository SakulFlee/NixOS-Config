{ config, pkgs, inputs, ... }: {
  # Install the SMB/CIFS client utilities
  environment.systemPackages = [ pkgs.cifs-utils ];

  # Define the actual SMB Mount
  fileSystems."/mnt/nas" = {
    device = "//192.168.178.250/personal_folder";
    fsType = "cifs";
    options = [
      # Crucial: Link to the decrypted runtime path provided by sops-nix
      "credentials=/run/secrets/smb-credentials"
      
      "uid=1000"        # Maps files to your local user ID
      "gid=100"         # Maps files to the 'users' group ID
      "file_mode=0664"  # Gives you read/write access
      "dir_mode=0775"   # Gives you read/write/execute on folders
      
      # Automount on-demand so booting doesn't hang if the NAS is asleep
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60" # Unmounts after 60s of inactivity to save network resources
    ];
  };
}
