{ config, pkgs, lib, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  systemd.services.mautrix-whatsapp = {
    serviceConfig = {
      MemoryDenyWriteExecute = false;
      SystemCallFilter = [];
    };
    preStart = lib.mkAfter ''
      PICKLE_KEY_FILE="/var/lib/mautrix-whatsapp/pickle.key"
      if [ ! -f "$PICKLE_KEY_FILE" ]; then
        tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 64 > "$PICKLE_KEY_FILE"
        chmod 600 "$PICKLE_KEY_FILE"
      fi
      PICKLE_KEY=$(cat "$PICKLE_KEY_FILE")
      ${pkgs.yq}/bin/yq eval -i ".encryption.pickle_key = \"$PICKLE_KEY\"" /var/lib/mautrix-whatsapp/config.yaml
    '';
  };

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
