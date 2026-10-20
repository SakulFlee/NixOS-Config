{ config, pkgs, ... }:
let
  helper = pkgs.writeShellApplication {
    name = "vpn-run-helper";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.iproute2
      pkgs.util-linux
      config.systemd.package
    ];
    text = ''
      if [ "$(id -u)" -ne 0 ]; then
        echo "vpn-run-helper must be run as root" >&2
        exit 1
      fi

      envs=()
      while [ "$#" -gt 0 ]; do
        case "$1" in
          --env)
            envs+=("$2")
            shift 2
            ;;
          --)
            shift
            break
            ;;
          *)
            echo "vpn-run-helper: unexpected argument: $1" >&2
            exit 2
            ;;
        esac
      done

      if [ "$#" -lt 1 ]; then
        echo "vpn-run-helper: missing command" >&2
        exit 2
      fi

      if [ -z "''${SUDO_UID:-}" ] || [ -z "''${SUDO_GID:-}" ]; then
        echo "vpn-run-helper: must be invoked through sudo" >&2
        exit 1
      fi

      # A new launch counts as activity, so cancel any pending idle stop.
      rm -f /run/pia-idle-since

      if [ ! -e /run/netns/pia ]; then
        systemctl start pia.service
      fi

      exec ip netns exec pia \
        setpriv \
          --reuid="$SUDO_UID" \
          --regid="$SUDO_GID" \
          --init-groups \
          --inh-caps=-all \
          --bounding-set=-all \
          -- env "''${envs[@]}" "$@"
    '';
  };

  runner = pkgs.writeShellScriptBin "vpn-run" ''
    if [ "$#" -lt 1 ]; then
      echo "usage: vpn-run <command> [args...]" >&2
      exit 2
    fi

    cmd="$1"
    shift

    if [ "''${cmd#/}" = "$cmd" ]; then
      resolved="$(command -v -- "$cmd" || true)"
      if [ -z "$resolved" ]; then
        echo "vpn-run: command not found: $cmd" >&2
        exit 127
      fi
      cmd="$resolved"
    fi

    exec /run/wrappers/bin/sudo -n "${helper}/bin/vpn-run-helper" \
      --env "HOME=$HOME" \
      --env "USER=$USER" \
      --env "LOGNAME=$LOGNAME" \
      --env "SHELL=$SHELL" \
      --env "PATH=$PATH" \
      --env "XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
      --env "DBUS_SESSION_BUS_ADDRESS=''${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}" \
      --env "XDG_DATA_DIRS=''${XDG_DATA_DIRS:-/run/current-system/sw/share}" \
      --env "XDG_CONFIG_DIRS=''${XDG_CONFIG_DIRS:-/etc/xdg}" \
      --env "XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}" \
      --env "XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-$HOME/.config}" \
      --env "XDG_CACHE_HOME=''${XDG_CACHE_HOME:-$HOME/.cache}" \
      --env "XDG_STATE_HOME=''${XDG_STATE_HOME:-$HOME/.local/state}" \
      --env "WAYLAND_DISPLAY=''${WAYLAND_DISPLAY:-}" \
      --env "DISPLAY=''${DISPLAY:-}" \
      --env "XAUTHORITY=''${XAUTHORITY:-$HOME/.Xauthority}" \
      --env "PULSE_SERVER=''${PULSE_SERVER:-}" \
      --env "PIPEWIRE_REMOTE=''${PIPEWIRE_REMOTE:-}" \
      --env "QT_QPA_PLATFORM=''${QT_QPA_PLATFORM:-}" \
      --env "LANG=''${LANG:-C.UTF-8}" \
      --env "LC_ALL=''${LC_ALL:-}" \
      -- "$cmd" "$@"
  '';
in
{
  environment.systemPackages = [ runner ];
}
