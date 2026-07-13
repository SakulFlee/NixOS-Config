{ config, pkgs, lib, ... }: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "forgejo" "woodpecker" "bitmagnet" ];
    ensureUsers = [
      {
        name = "forgejo";
        ensureDBOwnership = true;
      }
      {
        name = "woodpecker";
        ensureDBOwnership = true;
      }
      {
        name = "bitmagnet";
        ensureDBOwnership = true;
      }
    ];
    authentication = ''
      local forgejo forgejo peer map=forgejo-map
      local woodpecker woodpecker peer map=woodpecker-map
      host bitmagnet bitmagnet 127.0.0.1/32 scram-sha-256
      host bitmagnet bitmagnet ::1/128 scram-sha-256
      host bitmagnet bitmagnet 10.88.0.0/16 scram-sha-256
    '';
    identMap = ''
      forgejo-map /^(forgejo|git)$ forgejo
      woodpecker-map /^(woodpecker)$ woodpecker
    '';
    settings = {
      listen_addresses = lib.mkForce "localhost,10.88.0.1";
      logging_collector = true;
      log_directory = "log";
    };
  };

  systemd.services.postgresql = {
    postStart = lib.mkAfter ''
      psql -d bitmagnet -c "ALTER USER bitmagnet WITH PASSWORD 'bitmagnet';" 2>/dev/null || true
    '';
  };
}
