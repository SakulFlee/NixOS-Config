{ config, ... }: {
  sops.secrets."mautrix-whatsapp-env" = {};

  services.mautrix-whatsapp = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-whatsapp-env".path;
    settings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "sakul-flee.de";
      };
      bridge = {
        double_puppet_server_url = "https://matrix.sakul-flee.de";
        displayname_check = false;
      };
    };
  };
}
