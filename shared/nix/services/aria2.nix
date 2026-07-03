{ pkgs, ... }:
{
  services.aria2 = {
    enable = true;
    rpcSecretFile = "/var/lib/aria2/secret.txt";
    settings = {
      enable-rpc = true;
      dir = "/home/sakulflee/Downloads/"
    };
    openPorts = true;
  };

  systemd.services.aria2 = {
    preStart = ''
      mkdir -p /var/lib/aria2
      chmod 750 /var/lib/aria2
      if [ ! -f /var/lib/aria2/secret.txt ]; then
        # Generate a random 32-character hex string
        ${pkgs.openssl}/bin/openssl rand -hex 16 > /var/lib/aria2/secret.txt
        chmod 600 /var/lib/aria2/secret.txt
        chown aria2:aria2 /var/lib/aria2/secret.txt
      fi
    '';
  };
}
