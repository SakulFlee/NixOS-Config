{ config, ... }: {
  sops.secrets."mautrix-discord-env" = {};

  services.mautrix-discord = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-discord-env".path;
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
