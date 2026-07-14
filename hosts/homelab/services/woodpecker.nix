{ config, pkgs, ... }: {
  sops.secrets."woodpecker-server-env" = {};
  sops.secrets."woodpecker-agent-env" = {};

  users.groups.woodpecker = {};
  users.users.woodpecker = {
    isSystemUser = true;
    group = "woodpecker";
    extraGroups = [ "podman" ];
    home = "/var/lib/woodpecker";
    createHome = true;
  };

  systemd.services.woodpecker-server = {
    description = "Woodpecker CI server";
    documentation = [ "https://woodpecker-ci.org/docs/administration/server-config" ];
    after = [ "network.target" "postgresql.service" ];
    wants = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "woodpecker";
      Group = "woodpecker";
      EnvironmentFile = [ config.sops.secrets."woodpecker-server-env".path ];
      ExecStart = "${pkgs.woodpecker-server}/bin/woodpecker-server";
      WorkingDirectory = "/var/lib/woodpecker";
      StateDirectory = "woodpecker";
      Restart = "on-failure";
    };
  };

  systemd.services.woodpecker-agent = {
    description = "Woodpecker CI agent";
    documentation = [ "https://woodpecker-ci.org/docs/administration/agent-config" ];
    after = [ "network.target" "woodpecker-server.service" ];
    wants = [ "network.target" "woodpecker-server.service" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ podman ];
    serviceConfig = {
      Type = "simple";
      User = "woodpecker";
      Group = "woodpecker";
      EnvironmentFile = [ config.sops.secrets."woodpecker-agent-env".path ];
      Environment = [
        "WOODPECKER_MAX_WORKFLOWS=1"
        "WOODPECKER_BACKEND_ENGINE=docker"
        "WOODPECKER_AGENT_LABELS=type=linux"
        "WOODPECKER_AGENT_NAME=HomeLab"
        "WOODPECKER_SERVER=localhost:9000"
        "WOODPECKER_AGENT_HTTP_PORT=3001"
      ];
      ExecStart = "${pkgs.woodpecker-agent}/bin/woodpecker-agent";
      WorkingDirectory = "/var/lib/woodpecker";
      StateDirectory = "woodpecker";
      Restart = "on-failure";
      RestartSec = 5;
      CPUQuota = "400%";
      MemoryMax = "8G";
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  # All ports are internal — Caddy reverse-proxies to localhost

  services.homelab-restic = {
    enable = true;
    paths = [
      "/var/lib/woodpecker"
      "/var/lib/postgresql"
    ];
  };
}
