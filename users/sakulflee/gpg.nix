{ config, osConfig, pkgs, lib, inputs, ...}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # Take values from Nix* sops config
    defaultSopsFile   = osConfig.sops.defaultSopsFile;
    defaultSopsFormat = osConfig.sops.defaultSopsFormat;

    # Use user SSH key to bypass Home-Manager being unable to access host SSH keys
    age.sshKeyPaths   = [ "/home/sakulflee/.ssh/id_ed25519" ];

    # Declare secret to expose here
    secrets."gpg-private-key" = {
      path = "${config.programs.gpg.homedir}/private-keys-v1.d/0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05.key";
    };

    # Tell SOPS where where to put GPG key
    gnupg.home = "${config.programs.gpg.homedir}";
  };

  programs.gpg = {
    enable = true;

    settings = {
      trusted-key = "0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05";
    };

    publicKeys = [
      {
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEZsz8ExYJKwYBBAHaRw8BAQdAMp0H2LrUQIQsdzo6JFEbiYPnR6kvgLpAY6hW
          1u9C9jq0Hkx1a2FzIFdlYmVyIDxtZUBzYWt1bC1mbGVlLmRlPoicBBMWCgBEAhsj
          BQkFpEINBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAFiEECpbJqnLbAZ3hcef3
          fwxq8fVqngUFAmbM/MICGQEACgkQfwxq8fVqngWF8QD+NcUv3M94voI6GHo/kUsc
          /B1ELih6FU4u5Zt13OCXdlUA/1UM+Ukrsh5/WHxvxZA0ryKpRc4430N6ibJRbRRZ
          DGUCtCFMdWthcyBXZWJlciA8bHVrYXNAc2FrdWwtZmxlZS5kZT6ImQQTFgoAQRYh
          BAqWyapy2wGd4XHn938MavH1ap4FBQJmzPxgAhsjBQkFpEINBQsJCAcCAiICBhUK
          CQgLAgQWAgMBAh4HAheAAAoJEH8MavH1ap4FVbMBAKWtku8KbnVcPbCEL4XmI3Rs
          0ZoYW8TRA2IDJV4vrIxzAQDYGc+YoHu3zo0ATFrmVChe2b9ct/WP327CoNQ3MtOD
          ArQjTHVrYXMgV2ViZXIgPGwud2ViZXJAc2FrdWwtZmxlZS5kZT6ImQQTFgoAQRYh
          BAqWyapy2wGd4XHn938MavH1ap4FBQJmzPxlAhsjBQkFpEINBQsJCAcCAiICBhUK
          CQgLAgQWAgMBAh4HAheAAAoJEH8MavH1ap4FMQcBAKzv1lyr7Dzy3kRIFhNM3LV0
          /Op+BVU22aDM+acfN78DAQDUjtTb+4upAwqfs7BNkKkyV89nSamuRWhAzXTkF+ZA
          DbQfTHVrYXMgV2ViZXIgPGRldkBzYWt1bC1mbGVlLmRlPoiZBBMWCgBBFiEECpbJ
          qnLbAZ3hcef3fwxq8fVqngUFAmbM/GsCGyMFCQWkQg0FCwkIBwICIgIGFQoJCAsC
          BBYCAwECHgcCF4AACgkQfwxq8fVqngWCdQEA7yir7zbLlv+ownwBHUXtvVjgGQ1j
          T/eEtVou7PG44HwA/1AFUb5JA7osg8KuKS5O7DSyugtryeQCM0wL2Yq0dZEGtCFM
          dWthcyBXZWJlciA8c2FrdWxmbGVlQGdtYWlsLmNvbT6ImQQTFgoAQRYhBAqWyapy
          2wGd4XHn938MavH1ap4FBQJmzPyOAhsjBQkFpEINBQsJCAcCAiICBhUKCQgLAgQW
          AgMBAh4HAheAAAoJEH8MavH1ap4FXFgBAODOArsjsch4IEDBJShKb9VLEdaE1ISY
          PY86LJFHdRbkAQD9kuG0IaTolnYXVv/tOyaComeHJEf9pTusVIwtJtSeCLg4BGbM
          /BMSCisGAQQBl1UBBQEBB0B+NnSj8RWynC5Do1trjpg8px0fNh7/yCQIABaHd9Ya
          PQMBCAeIfgQYFgoAJhYhBAqWyapy2wGd4XHn938MavH1ap4FBQJmzPwTAhsMBQkF
          pEINAAoJEH8MavH1ap4FCKEBAJfexZoNFJ6HpTBv3rR1EmSgT8H8OwAi1R4KUBCz
          8QaPAQCxdFkx5kTnJvEtGrM/1cmNQQoNta1X/U5M9EUIuw0QDg==
          =YJUl
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        trust = 5;
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt; # KDE popup for password entry
    enableSshSupport = true;            # Optional: lets GPG act as your SSH agent too
  };

  # Import GPG key
  home.file."${config.programs.gpg.homedir}/.import-token" = {
    text = "timestamp: 2026"; 
    onChange = ''
      if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys 0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05 >/dev/null 2>&1; then
        echo "Importing private GPG key safely..."
        ${pkgs.gnupg}/bin/gpg --batch --import ${config.sops.secrets."gpg-private-key".path}
      fi
    '';
  };
}
