{ config, pkgs, lib, ...}: {
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

  home.activation = {
    importGpgKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Only import if GPG doesn't already have this key active
      if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys 0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05 >/dev/null 2>&1; then
        echo "Importing private GPG key from SOPS..."
        ${pkgs.gnupg}/bin/gpg --import ${config.sops.secrets.gpg-private-key.path}
      fi
    '';
  };
}
