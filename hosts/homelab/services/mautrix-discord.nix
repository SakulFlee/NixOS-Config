{ config, pkgs, lib, ... }: {
  sops.secrets."mautrix-discord-env" = {};

  services.mautrix-discord = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-discord-env".path;
    settings = {
      bridge = {
        displayname_check = false;
        federation = true;
      };
    };
  };
}
