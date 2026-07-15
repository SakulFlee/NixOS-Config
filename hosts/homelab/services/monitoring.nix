{ pkgs, lib, ... }: {
  # Prometheus — metrics collection
  services.prometheus = {
    enable = true;
    port = 9090;
    listenAddress = "127.0.0.1";
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{
          targets = [ "127.0.0.1:9100" ];
        }];
      }
    ];
    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9100;
      listenAddress = "127.0.0.1";
    };
  };

  # Grafana — dashboards
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3002;
        domain = "grafana.sakul-flee.de";
        root_url = "https://grafana.sakul-flee.de";
      };
      analytics.reporting_enabled = false;
      auth.anonymous.enabled = false;
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [{
        name = "Prometheus";
        type = "prometheus";
        url = "http://127.0.0.1:9090";
        access = "proxy";
        isDefault = true;
      }];
    };
  };

  # Open firewall for Grafana (Prometheus is localhost-only)
  networking.firewall.allowedTCPPorts = [ 3002 ];
}
