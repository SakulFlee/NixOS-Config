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
      # Xiaomi tablet running Termux (set a DHCP reservation for this IP)
      "tablet" = {
        HostName = "192.168.178.106";
        Port = 8022;
        User = "u0_a510";
      };
    };
  };

  sops.secrets."ssh_private_key" = {
    path = "${config.home.homeDirectory}/.ssh/id_ed25519";
  };
}
