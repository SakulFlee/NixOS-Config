{ config, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  systemd.services.mautrix-discord.serviceConfig = {
    MemoryDenyWriteExecute = false;
  };

  services.mautrix-discord = {
    enable = true;
    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "sakul-flee.de";
      };
      bridge = {
        displayname_check = false;
        federation = true;
      };
    };
  };
}
