{ config, ... }: {
  services.technitium-dns-server = {
    enable = true;
  };

  systemd.services.technitium-dns-server.serviceConfig = {
    LogsDirectory = "technitium";
  };

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/private/technitium-dns-server/" ];
  };
}
