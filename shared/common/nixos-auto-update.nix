{ pkgs, ... }:

let
  nixos-auto-update-helper = pkgs.writeShellScriptBin "nixos-auto-update" ''
    set -e
    CMD="''${1:-start}"
    
    # Tail journal in background
    journalctl -u nixos-auto-update -f --no-hostname -o short &
    JPID=$!
    
    # Run the systemctl command
    systemctl "$CMD" nixos-auto-update
    EC=$?
    
    # Kill journal tail
    kill $JPID 2>/dev/null || true
    exit $EC
  '';
in {
  environment.systemPackages = [ nixos-auto-update-helper ];
}
