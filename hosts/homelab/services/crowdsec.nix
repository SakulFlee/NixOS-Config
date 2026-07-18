{ config, pkgs, ... }: {
  systemd.tmpfiles.rules = [
    "d /var/log/caddy 0755 caddy caddy -"
  ];

  services.crowdsec = {
    enable = true;

    settings.general.api.server.enable = true;
    settings.lapi.credentialsFile = "/var/lib/crowdsec/state/lapi-api-key.yaml";

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

    localConfig.parsers.s02Enrich = [
      {
        name = "homelab/whitelist";
        description = "Whitelist home LAN and VPN networks";
        whitelist = {
          reason = "Trusted internal networks";
          cidr = [
            "192.168.178.0/24"
            "10.100.0.0/24"
          ];
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
