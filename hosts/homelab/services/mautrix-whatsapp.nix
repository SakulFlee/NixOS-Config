{ config, ... }: {
  services.mautrix-whatsapp = {
    enable = true;
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
