{ config, pkgs, lib, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  systemd.services.mautrix-whatsapp.serviceConfig = {
    MemoryDenyWriteExecute = false;
    SystemCallFilter = [];
  };

  # WhatsApp bridge needs an encryption pickle key (Discord doesn't).
  # Generate one on first start if it doesn't exist.
  systemd.services.mautrix-whatsapp.preStart = lib.mkAfter ''
    if [ ! -f /var/lib/mautrix-whatsapp/env ]; then
      umask 077
      echo "ENCRYPTION_PICKLE_KEY=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c64)" > /var/lib/mautrix-whatsapp/env
    fi
  '';
  systemd.services.mautrix-whatsapp.serviceConfig.EnvironmentFile = lib.mkForce "-/var/lib/mautrix-whatsapp/env";

  # Declare encryption capability in the registration file
  systemd.services.mautrix-whatsapp.postStart = ''
    ${pkgs.yq}/bin/yq -i -y '.de.mau.matrix.encryption = true' \
      /var/lib/mautrix-whatsapp/whatsapp-registration.yaml
  '';

  services.mautrix-whatsapp = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "sakul-flee.de";
      };
      appservice = {
        hostname = "[::]";
        port = 29318;
        id = "whatsapp";
        bot = {
          username = "whatsappbot";
          displayname = "WhatsApp Bridge Bot";
        };
      };
      bridge = {
        command_prefix = "!wa";
        encryption = {
          allow = true;
          default = true;
        };
        relay = {
          enabled = true;
        };
        permissions = {
          "sakul-flee.de" = "admin";
          "*" = "relay";
        };
        double_puppet_server_url = "https://matrix.sakul-flee.de";
        displayname_check = false;
      };
      database = {
        type = "sqlite3-fk-wal";
        uri = "file:/var/lib/mautrix-whatsapp/mautrix-whatsapp.db?_txlock=immediate";
      };
    };
  };
}
