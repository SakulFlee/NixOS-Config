{ config, pkgs, inputs, ... }: {
  # Enable sops-nix module
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # Tell SOPS where your encrypted file lives in your repo
  sops.defaultSopsFile = ../secrets/nas-smb-credentials.yaml;
  sops.defaultSopsFormat = "yaml";

  # Tell SOPS which keys to use for decryption on the hardware
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets.smb-secrets = {
    format = "yaml";
  };

  # Install the SMB/CIFS client utilities
  environment.systemPackages = [ pkgs.cifs-utils ];

  # Define the actual SMB Mount
  fileSystems."/mnt/nas" = {
    device = "//192.168.178.250/personal_folder";
    fsType = "cifs";
    options = [
      # Crucial: Link to the decrypted runtime path provided by sops-nix
      "credentials=/run/secrets/smb-secrets"
      
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
