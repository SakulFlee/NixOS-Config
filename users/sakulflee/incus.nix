{
  config,
  lib,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "incus_client_crt" = { };
    "incus_client_key" = { };
    "incus_server_crt" = { };
  };

  home.file.".config/incus/config.yml" = {
    force = true;
    text = ''
      default-remote: sakul-flee
      remotes:
        images:
          protocol: simplestreams
          public: true
          addr: https://images.linuxcontainers.org
        local:
          protocol: incus
          public: false
          addr: unix://
        sakul-flee:
          addr: https://incus.sakul-flee.de:8443
          auth_type: tls
          protocol: incus
          public: false
      aliases: {}
      defaults:
        list_format: ""
        console_type: ""
        console_spice_command: ""
        no_color: false
    '';
  };

  home.activation.setupIncusClientCerts = lib.hm.dag.entryAfter [ "sops-nix" "writeBoundary" ] ''
    incus_install_secret() {
      src="$1"
      target="$2"
      mode="$3"
      if [ -f "$src" ]; then
        if ! ${pkgs.diffutils}/bin/cmp -s "$src" "$target"; then
          ${pkgs.coreutils}/bin/install -D -m "$mode" "$src" "$target"
        fi
      else
        echo "Incus secret $src not available yet, skipping"
      fi
    }

    incusDir="${config.home.homeDirectory}/.config/incus"
    ${pkgs.coreutils}/bin/install -d -m 0700 "$incusDir/servercerts"
    incus_install_secret "${config.sops.secrets."incus_client_crt".path}" "$incusDir/client.crt" 0600
    incus_install_secret "${config.sops.secrets."incus_client_key".path}" "$incusDir/client.key" 0600
    incus_install_secret "${
      config.sops.secrets."incus_server_crt".path
    }" "$incusDir/servercerts/sakul-flee.crt" 0644
  '';
}
