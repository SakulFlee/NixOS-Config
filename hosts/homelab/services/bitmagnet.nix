{ config, pkgs, lib, ... }:
let
  podmanGateway = "10.88.0.1";

  bitmagnetEnv = pkgs.writeShellScript "bitmagnet-env-pre" ''
    mkdir -p /run/gluetun
    USER=$(cat ${config.sops.secrets.vpn_pia_username.path})
    PASS=$(cat ${config.sops.secrets.vpn_pia_password.path})
    echo "OPENVPN_USER=$USER" > /run/gluetun/env
    echo "OPENVPN_PASSWORD=$PASS" >> /run/gluetun/env
  '';
in {
  sops.secrets."vpn_pia_username" = {};
  sops.secrets."vpn_pia_password" = {};

  systemd.tmpfiles.settings."bitmagnet" = {
    "/var/lib/gluetun"."d" = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    "/var/lib/bitmagnet/config"."d" = {
      mode = "0755";
      user = "root";
      group = "root";
    };
    "/var/lib/bitmagnet/data"."d" = {
      mode = "0755";
      user = "root";
      group = "root";
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
      containers = {
        gluetun = {
          image = "qmcgaw/gluetun:latest";
          ports = [
            "3333:3333/tcp"
            "3334:3334/tcp"
            "3334:3334/udp"
          ];
          environment = {
            VPN_SERVICE_PROVIDER = "private internet access";
            VPN_TYPE = "openvpn";
            HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE = "{\"auth\":\"none\"}";
            FIREWALL_OUTBOUND_SUBNETS = "${podmanGateway}/32";
          };
          environmentFiles = [ "/run/gluetun/env" ];
          extraOptions = [ "--cap-add=NET_ADMIN" ];
          volumes = [ "/var/lib/gluetun:/gluetun" ];
        };
        bitmagnet = {
          image = "ghcr.io/bitmagnet-io/bitmagnet:latest";
          dependsOn = [ "gluetun" ];
          extraOptions = [ "--network=container:gluetun" ];
          environment = {
            POSTGRES_HOST = podmanGateway;
            POSTGRES_PORT = "5432";
            POSTGRES_DB = "bitmagnet";
            POSTGRES_USER = "bitmagnet";
            POSTGRES_PASSWORD = "bitmagnet";
            LOG_LEVEL = "info";
          };
          volumes = [
            "/var/lib/bitmagnet/config:/root/.config/bitmagnet"
            "/var/lib/bitmagnet/data:/root/.local/share/bitmagnet"
          ];
          cmd = [
            "worker"
            "run"
            "--keys=http_server,queue_server,dht_crawler"
          ];
        };
      };
    };
  };

  systemd.services."podman-gluetun" = {
    after = [ "network.target" ];
    path = with pkgs; [ gnused ];
    serviceConfig.ExecStartPre = [ "${bitmagnetEnv}" ];
  };
}
