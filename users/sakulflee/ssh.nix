{ config, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        SetEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };

  sops.secrets."ssh_private_key" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  };
}
