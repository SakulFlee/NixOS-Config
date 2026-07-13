{ config, pkgs, lib, ... }: {
  sops.secrets."mautrix-whatsapp-env" = {};

  services.mautrix-whatsapp = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-whatsapp-env".path;
    settings = {
      bridge = {
        double_puppet_server_url = "https://matrix.sakul-flee.de";
        displayname_check = false;
      };
    };
  };
}
