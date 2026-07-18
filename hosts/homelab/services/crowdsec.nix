{ config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy -"
  ];

  services.crowdsec = {
    enable = true;

    settings.general.api.server.enable = true;

    localConfig.acquisitions = [
      {
        source = "journalctl";
        journalctl_filter = [ "_SYSTEMD_UNIT=sshd.service" ];
        labels = {
          type = "syslog";
        };
      }
      {
        source = "file";
        filenames = [ "/var/log/caddy/access.log" ];
        labels = {
          type = "caddy";
        };
      }
    ];

    hub.collections = [ "crowdsecurity/linux" ];
    hub.parsers = [ "crowdsecurity/caddy-logs" ];
  };

  services.crowdsec-firewall-bouncer = {
    enable = true;
  };
}
