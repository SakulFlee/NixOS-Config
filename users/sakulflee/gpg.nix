{
  config,
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    # Take values from Nix* sops config
    defaultSopsFile = osConfig.sops.defaultSopsFile;
    defaultSopsFormat = osConfig.sops.defaultSopsFormat;

    # Dedicated age decryptor (real file on disk, not a SOPS secret) so
    # login-time decryption is unattended — no pinentry/GPG prompt.
    age.sshKeyPaths = [ "/home/sakulflee/.ssh/sops_key" ];

    # Declare secret to expose here (onChange hook handles import into GPG keyring)
    secrets."gpg_private_key" = { };
  };

  programs.gpg = {
    enable = true;

    settings = {
      trusted-key = "93842616D9E2EF9B41078EB833CC460FF18CDFFC";
    };

    publicKeys = [
      {
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEamPxpBYJKwYBBAHaRw8BAQdAKHOdpStUm9nE/5oA1fNDsOqlkjusm/AS9KmE
          27H0xD20I0x1a2FzIFdlYmVyIDxsLndlYmVyQHNha3VsLWZsZWUuZGU+iJYEExYK
          AD4WIQSThCYW2eLvm0EHjrgzzEYP8Yzf/AUCamPyOAIbAwUJBaOaxgULCQgHAgYV
          CgkICwIEFgIDAQIeAQIXgAAKCRAzzEYP8Yzf/J3LAQDFe18AjMvJyz690xN7bmjZ
          QPmYKQQyoQUim1NQhrJMAQEAj7BbzAndsXenVAEwGVWvbqpCJrv3tfV+zibU53TQ
          vwK0Ikx1a2FzIFdlYmVyIDxsd2ViZXJAc2FrdWwtZmxlZS5kZT6IlgQTFgoAPgIb
          AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBJOEJhbZ4u+bQQeOuDPMRg/xjN/8
          BQJqY/HqBQkFo5rGAAoJEDPMRg/xjN/8z70A/2DABAfINdo+pD82Rt+ng4yLoYtz
          7VfmSYYyZK5hxnbuAP9aNPHJAujxvmdSRQu/6sZSIVkKLSo/liB1rJLRvTqPALQe
          THVrYXMgV2ViZXIgPG1lQHNha3VsLWZsZWUuZGU+iJYEExYKAD4WIQSThCYW2eLv
          m0EHjrgzzEYP8Yzf/AUCamPyJwIbAwUJBaOaxgULCQgHAgYVCgkICwIEFgIDAQIe
          AQIXgAAKCRAzzEYP8Yzf/CESAP9qZ13mDlItRGWIKu0r+skeoWqwU1x6oXL/zevg
          edaeAQEA1QwsD9NaYynSezME62EvbzyrTwiI5g3uuEPAC1bKYgO0H0x1a2FzIFdl
          YmVyIDxkZXZAc2FrdWwtZmxlZS5kZT6IlgQTFgoAPhYhBJOEJhbZ4u+bQQeOuDPM
          Rg/xjN/8BQJqY/IvAhsDBQkFo5rGBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJ
          EDPMRg/xjN/8pk0BANRUkUtXTSWUzE6GNOMRhqNGHWtfc7AsOKHf2a7eD23kAP9U
          TTIDT/uurkxwqd+y/LduTnZZmUADz+8j0pewR8hVA7g4BGpj8aQSCisGAQQBl1UB
          BQEBB0AzU0g7LD64OqrgAZ7bTICubATFGRdkcHpqW6v/o0s2BAMBCAeIfgQYFgoA
          JhYhBJOEJhbZ4u+bQQeOuDPMRg/xjN/8BQJqY/GkAhsMBQkB4TOAAAoJEDPMRg/x
          jN/8lnoA/A2QrkdGxNCgEP/yWIaxMmljM4S26AP2trJhvTVWVBKAAP4mbRIfSgvq
          TXcQRMh+R1k713yqYzjlYwwYk25lFMIHDrg4BGrL/wsSCisGAQQBl1UBBQEBB0Cf
          FOajPs+vTbtEstEELkY14X7QtsMvs3mEJnnL8DQHGwMBCAeIeAQYFgoAIBYhBJOE
          JhbZ4u+bQQeOuDPMRg/xjN/8BQJqy/8LAhsMAAoJEDPMRg/xjN/84ggBAI+RSNZi
          s7huzoGJL5ivYzew3KmLX0F6PbAzPqeIw243AQCWsP/aDSs7IiIV82hMCFlHGXW+
          pxgrXwbJEqA+CwxxCA==
          =sPTo
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        trust = 5;
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt; # KDE popup for password entry

    # Cache time-to-live settings (values are in seconds)
    defaultCacheTtl = 14400; # 4 hours (re-authenticates after 4 hours of inactivity)
    maxCacheTtl = 172800; # 48 hours (forces re-entry after 48 hours max)
  };

  # Import GPG key on every activation (idempotent — skips if already present)
  home.activation.importGpgKey = lib.mkAfter ''
    if [ -f "${config.sops.secrets."gpg_private_key".path}" ]; then
      if ! ${pkgs.gnupg}/bin/gpg --list-secret-keys 93842616D9E2EF9B41078EB833CC460FF18CDFFC >/dev/null 2>&1; then
        echo "Importing private GPG key safely..."
        ${pkgs.gnupg}/bin/gpg --batch --import ${config.sops.secrets."gpg_private_key".path}
      fi
    else
      echo "GPG private key secret not available yet, skipping import"
    fi
  '';
}
