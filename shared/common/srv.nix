{ pkgs, ... }:

let
  srv = pkgs.writeShellScriptBin "srv" ''
    set -e
    if [ $# -lt 1 ]; then
      echo "Usage: srv <service> [action]"
      echo "  action defaults to 'start'"
      echo "  Examples:"
      echo "    srv nixos-auto-update"
      echo "    srv nixos-auto-update restart"
      echo "    srv postgresql status"
      exit 1
    fi

    SERVICE="$1"
    CMD="''${2:-start}"

    # Kill any previous journalctl -f for the same service
    pkill -f "journalctl -u $SERVICE -f" 2>/dev/null || true

    # Tail journal in background
    journalctl -u "$SERVICE" -f --no-hostname -o short &
    JPID=$!

    # Run the systemctl command
    systemctl "$CMD" "$SERVICE"
    EC=$?

    # Kill journal tail
    kill $JPID 2>/dev/null || true
    exit $EC
  '';
in {
  environment.systemPackages = [ srv ];
}
