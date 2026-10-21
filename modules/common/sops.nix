{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Enable sops-nix module
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # Tell SOPS where your encrypted file lives in your repo
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # Credentials file for the NAS SMB mounts
  sops.secrets.smb_credentials = { };

  # Sets the GPG key location for SOPS
  sops.gnupg = {
    home = "/home/sakulflee/.gnupg";
    # Unset the default (host RSA SSH key) — exactly one key source allowed
    sshKeyPaths = [ ];
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
