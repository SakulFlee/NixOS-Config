{
  config,
  lib,
  pkgs,
  ...
}:
let
  piaRegion = "nl_amsterdam";

  # PIA server certificates are signed by PIA's own CA, published in the
  # official manual-connections repository.
  piaCa = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/pia-foss/manual-connections/master/ca.rsa.4096.crt";
    hash = "sha256-Mumx0UM+qXYU8qFMbjWOP1fAVwzJ9rLugSaZumlsZqs=";
  };

  # PIA does not keep static WireGuard peers: a token, server and peer have to
  # be obtained again for every connection. This runs before pia-up and writes
  # the config that pia-up consumes.
  piaConfig = pkgs.writeShellApplication {
    name = "pia-config";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
      pkgs.jq
      pkgs.wireguard-tools
    ];
    text = ''
      set -euo pipefail

      region=${piaRegion}
      ca=${piaCa}
      user_file=${config.sops.secrets."pia_username".path}
      pass_file=${config.sops.secrets."pia_password".path}

      user="$(<"$user_file")"
      pass="$(<"$pass_file")"

      token="$(curl -fsS --location --request POST \
        'https://www.privateinternetaccess.com/api/client/v2/token' \
        --form "username=$user" \
        --form "password=$pass" | jq -r '.token // empty')"

      if [ -z "$token" ]; then
        echo "PIA: authentication failed" >&2
        exit 1
      fi

      # The server list response is one JSON line followed by a blank line and
      # the signature, so only the first line is JSON.
      install -d -m 0700 /run/pia
      servers_tmp="$(mktemp /run/pia/servers.XXXXXX)"
      trap 'rm -f "$servers_tmp"' EXIT

      curl -fsS --compressed \
        'https://serverlist.piaservers.net/vpninfo/servers/v6' \
        -o "$servers_tmp"

      servers="$(head -n 1 "$servers_tmp" | jq -r --arg region "$region" \
        '.regions[] | select(.id == $region) | .servers.wg[] | "\(.ip) \(.cn)"')"

      rm -f "$servers_tmp"
      trap - EXIT

      if [ -z "$servers" ]; then
        echo "PIA: no WireGuard servers for region $region" >&2
        exit 1
      fi

      priv="$(wg genkey)"
      pub="$(printf '%s' "$priv" | wg pubkey)"

      chosen_ip=""
      chosen_cn=""
      peer_ip=""
      server_key=""
      server_port=""
      dns=""

      while read -r ip cn; do
        [ -n "$ip" ] || continue

        response="$(curl -sS -G \
          --connect-to "$cn::$ip:" \
          --cacert "$ca" \
          --data-urlencode "pt=$token" \
          --data-urlencode "pubkey=$pub" \
          "https://$cn:1337/addKey" || true)"

        status="$(printf '%s' "$response" | jq -r '.status // empty' 2>/dev/null || true)"
        if [ "$status" != "OK" ]; then
          echo "PIA: $cn ($ip) did not accept the key" >&2
          continue
        fi

        chosen_ip="$ip"
        chosen_cn="$cn"
        peer_ip="$(printf '%s' "$response" | jq -r '.peer_ip // empty')"
        server_key="$(printf '%s' "$response" | jq -r '.server_key // empty')"
        server_port="$(printf '%s' "$response" | jq -r '.server_port // empty')"
        dns="$(printf '%s' "$response" | jq -r '.dns_servers[0] // empty')"
        break
      done <<< "$servers"

      if [ -z "$chosen_ip" ] || [ -z "$peer_ip" ] || [ -z "$server_key" ]; then
        echo "PIA: no server accepted the WireGuard key" >&2
        exit 1
      fi

      [ -n "$server_port" ] || server_port=1337
      [ -n "$dns" ] || dns=10.0.0.243

      install -d -m 0700 /run/pia
      umask 077
      tmp="$(mktemp /run/pia/wg.XXXXXX)"
      trap 'rm -f "$tmp"' EXIT

      {
        printf '[Interface]\n'
        printf 'Address = %s\n' "$peer_ip"
        printf 'PrivateKey = %s\n' "$priv"
        printf 'DNS = %s\n' "$dns"
        printf '\n[Peer]\n'
        printf 'PublicKey = %s\n' "$server_key"
        printf 'Endpoint = %s:%s\n' "$chosen_ip" "$server_port"
        printf 'AllowedIPs = 0.0.0.0/0\n'
        printf 'PersistentKeepalive = 25\n'
      } > "$tmp"

      mv "$tmp" /run/pia/wg.conf
      trap - EXIT
      echo "PIA: generated config for $chosen_cn ($chosen_ip)" >&2
    '';
  };

  # pia-up only proves that the endpoint answers ICMP. Verify the actual
  # WireGuard handshake so a stale or rejected peer fails the start instead of
  # silently leaving the application without connectivity.
  piaHealthcheck = pkgs.writeShellApplication {
    name = "pia-healthcheck";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gawk
      pkgs.iproute2
      pkgs.wireguard-tools
    ];
    text = ''
      for _ in $(seq 1 10); do
        if ip netns exec pia wg show pia0 latest-handshakes 2>/dev/null |
          awk '$2 != 0 { found = 1 } END { exit !found }'; then
          exit 0
        fi
        sleep 1
      done

      echo "PIA: WireGuard handshake did not complete" >&2
      exit 1
    '';
  };
in
{
  sops.secrets."pia_username" = {
    key = "pia/username";
    mode = "0400";
  };
  sops.secrets."pia_password" = {
    key = "pia/password";
    mode = "0400";
  };

  # The namespace is used by GUI applications launched through `vpn-run`
  # (see modules/desktop/vpn-gui.nix). No ports are published.
  vpnNamespaces.pia = {
    enable = true;
    wireguardConfigFile = "/run/pia/wg.conf";
  };

  # The namespace is created on demand by vpn-run, not at boot. Each start
  # regenerates the WireGuard config because PIA does not keep static peers.
  systemd.services.pia = {
    wantedBy = lib.mkForce [ ];
    preStart = "${piaConfig}/bin/pia-config";
    postStart = "${piaHealthcheck}/bin/pia-healthcheck";
    serviceConfig = {
      RuntimeDirectory = "pia";
      RuntimeDirectoryMode = "0700";
    };
  };

  # Stop the namespace once no confined process has been running for a while.
  # The timestamp file makes this a two-minute idle timeout even though the
  # check itself runs every minute.
  systemd.services.pia-idle-stop = {
    serviceConfig.Type = "oneshot";
    path = [
      config.systemd.package
      pkgs.iproute2
      pkgs.coreutils
    ];
    script = ''
      set -eu

      systemctl is-active --quiet pia.service || {
        rm -f /run/pia-idle-since
        exit 0
      }

      pids="$(ip netns pids pia 2>/dev/null || true)"
      if [ -n "$pids" ]; then
        rm -f /run/pia-idle-since
        exit 0
      fi

      if [ ! -e /run/pia-idle-since ]; then
        touch /run/pia-idle-since
        exit 0
      fi

      [ $(( $(date +%s) - $(stat -c %Y /run/pia-idle-since) )) -ge 120 ] || exit 0

      systemctl stop pia.service
      rm -f /run/pia-idle-since
    '';
  };

  systemd.timers.pia-idle-stop = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "1min";
    };
  };
}
