{ config, ... }: {
  sops.secrets = {
    "openvpn_pia_username" = {
      key = "openvpn/pia/username";
    };
    "openvpn_pia_password" = {
      key = "openvpn/pia/password";
    };
  };

  sops.templates."pia-auth" = {
    content = ''
      ${config.sops.placeholder."openvpn_pia_username"}
      ${config.sops.placeholder."openvpn_pia_password"}
    '';
  };

  services.openvpn.servers.pia = {
    autoStart = false;
    updateResolvConf = true;
    authUserPass = config.sops.templates."pia-auth".path;
    config = builtins.readFile ./openvpn-pia.conf;
  };
}
