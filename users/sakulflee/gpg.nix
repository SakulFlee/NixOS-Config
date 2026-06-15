{ config, osConfig, pkgs, lib, inputs, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # Take values from Nix* sops config
    defaultSopsFile   = osConfig.sops.defaultSopsFile;
    defaultSopsFormat = osConfig.sops.defaultSopsFormat;
    age.sshKeyPaths   = osConfig.sops.age.sshKeyPaths;

    # Use user SSH key to bypass Home-Manager being unable to access host SSH keys
    age.sshKeyPaths   = [ "/home/sakulflee/.ssh/id_ed25519" ];

    # Declare secret to expose here
    secrets."gpg-private-key" = {};
  };

  # Store secret GPG key into gpg homedir
  sops.secrets."gpg-private-key".path = "${config.programs.gpg.homedir}/private-key.asc";

  programs.gpg = {
    enable = true;

    settings = {
      trusted-key = "0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt; # KDE popup for password entry
    enableSshSupport = true;            # Optional: lets GPG act as your SSH agent too
  };
}
