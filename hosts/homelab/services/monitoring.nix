{ config, pkgs, lib, ... }:

let
  # Pre-provisioned Grafana dashboard: system overview
  node-dashboard = pkgs.writeText "node-dashboard.json" (builtins.toJSON {
    title = "HomeLab Overview";
    tags = [ "homelab" ];
    schemaVersion = 38;
    version = 1;
    time = { from = "now-1h"; to = "now"; };
    timepicker = {};
    panels = [
      {
        title = "CPU Usage";
        type = "gauge";
        gridPos = { h = 8; w = 6; x = 0; y = 0; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)";
          legendFormat = "CPU";
        }];
        options = { reduceOptions = { calcs = [ "lastNotNull" ]; }; };
      }
      {
        title = "Memory Usage";
        type = "gauge";
        gridPos = { h = 8; w = 6; x = 6; y = 0; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100";
          legendFormat = "RAM";
        }];
        options = { reduceOptions = { calcs = [ "lastNotNull" ]; }; };
      }
      {
        title = "Disk Usage";
        type = "gauge";
        gridPos = { h = 8; w = 6; x = 12; y = 0; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "(1 - (node_filesystem_avail_bytes{mountpoint=\"/\"} / node_filesystem_size_bytes{mountpoint=\"/\"})) * 100";
          legendFormat = "Root";
        }];
        options = { reduceOptions = { calcs = [ "lastNotNull" ]; }; };
      }
      {
        title = "CPU (5m)";
        type = "timeseries";
        gridPos = { h = 8; w = 12; x = 0; y = 8; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "100 - (avg by(instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)";
          legendFormat = "CPU";
        }];
      }
      {
        title = "Memory (5m)";
        type = "timeseries";
        gridPos = { h = 8; w = 12; x = 12; y = 8; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes";
          legendFormat = "Used";
        }];
      }
      {
        title = "Containers";
        type = "stat";
        gridPos = { h = 8; w = 6; x = 0; y = 16; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "count(count by(container_label_io_containerd_kubernetes_pod_namespace) (container_start_time_seconds)) or on() count(container_last_seen)";
          legendFormat = "Running";
        }];
      }
      {
        title = "SystemD Services";
        type = "table";
        gridPos = { h = 8; w = 18; x = 6; y = 16; };
        datasource = { type = "prometheus"; uid = "prometheus"; };
        targets = [{
          expr = "node_systemd_unit_state{state=\"active\"}";
          legendFormat = "{{name}}";
        }];
      }
    ];
  });
in {
  services.prometheus = {
    enable = true;
    port = 9090;
    listenAddress = "127.0.0.1";
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{ targets = [ "127.0.0.1:9100" ]; }];
      }
      {
        job_name = "cadvisor";
        static_configs = [{ targets = [ "127.0.0.1:8081" ]; }];
      }
      {
        job_name = "caddy";
        static_configs = [{ targets = [ "127.0.0.1:2019" ]; }];
      }
      {
        job_name = "forgejo";
        metrics_path = "/api/metrics";
        static_configs = [{ targets = [ "127.0.0.1:3002" ]; }];
      }
      {
        job_name = "postgres";
        static_configs = [{ targets = [ "127.0.0.1:9187" ]; }];
      }
    ];
    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9100;
      listenAddress = "127.0.0.1";
    };
  };

  # Cadvisor — container metrics (podman, docker, etc.)
  services.cadvisor = {
    enable = true;
    port = 8081;
    listenAddress = "127.0.0.1";
    extraOptions = [ "--docker_only=false" ];
  };

  # Grafana — dashboards
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3003;
        domain = "grafana.sakul-flee.de";
        root_url = "https://grafana.sakul-flee.de";
      };
      analytics.reporting_enabled = false;
      auth.anonymous.enabled = false;
      # Must be set (module assertion), but GRAFANA_SECRET_KEY env var
      # from EnvironmentFile takes precedence at runtime
      security.secret_key = "placeholder-overridden-by-env";
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
      dashboards.settings.providers = [{
        name = "HomeLab";
        options.path = "/etc/grafana/provisioning/dashboards";
      }];
    };
  };

  environment.etc."/etc/grafana/provisioning/dashboards/node.json".source = node-dashboard;

  # Generate a random Grafana secret key on first start
  systemd.services.grafana.preStart = ''
    if [ ! -f /var/lib/grafana/secret_key ]; then
      umask 077
      echo "GRAFANA_SECRET_KEY=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c40)" > /var/lib/grafana/secret_key
    fi
  '';
  systemd.services.grafana.serviceConfig.EnvironmentFile = "/var/lib/grafana/secret_key";

  networking.firewall.allowedTCPPorts = [ 3003 ];

  # PostgreSQL exporter (runs as a systemd service)
  systemd.services.postgres-exporter = {
    description = "Prometheus PostgreSQL Exporter";
    after = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.postgres_exporter}/bin/postgres_exporter \
        --web.listen-address=127.0.0.1:9187 \
        --data-source-name=postgresql://postgres@/postgres?host=/run/postgresql";
      Restart = "on-failure";
      User = "postgres";
    };
  };
}
