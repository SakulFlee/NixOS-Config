{ config, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  systemd.services.mautrix-whatsapp.serviceConfig = {
    MemoryDenyWriteExecute = false;
    SystemCallFilter = [];
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
        relay = {
          enabled = true;
        };
        permissions = {
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
