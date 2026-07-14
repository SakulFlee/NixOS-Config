{ config, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  systemd.services.mautrix-discord.serviceConfig = {
    ReadWritePaths = [ "/var/lib/mautrix-discord" ];
  };

  services.mautrix-discord = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "sakul-flee.de";
      };
      appservice = {
        database = {
          type = "sqlite3-fk-wal";
          uri = "file:/var/lib/mautrix-discord/mautrix-discord.db?_txlock=immediate";
        };
      };
      bridge = {
        permissions = {
          "*" = "relay";
        };
        displayname_check = false;
        federation = true;
      };
      logging = {
        min_level = "info";
        writers = [
          {
            type = "stdout";
            format = "pretty-colored";
            time_format = " ";
          }
        ];
      };
    };
  };
}
