{ config, pkgs, ... }:

let
  username = "sakulflee";
  workDir = "/home/${username}/.local/state/rclone/bisync";
  stateDir = "/home/${username}/.config/rclone";

  rcloneCleanupScript = pkgs.writeShellScriptBin "rclone-cleanup" ''
    #!/usr/bin/env bash

    WORK_DIR="${workDir}"
    STATE_DIR="${stateDir}"

    echo "Cleaning up rclone lock files..."

    # Remove all rclone lock files from work directory
    rm -f "$WORK_DIR"/*.lck 2>/dev/null

    # Remove all rclone lock files from state directory
    rm -f "$STATE_DIR"/*.lck 2>/dev/null

    echo "Lock cleanup complete."
  '';
in
{
  systemd.user.services.rclone-cleanup-on-shutdown = {
    description = "Cleanup rclone lock files on shutdown";
    wantedBy = [ "shutdown.target" ];
    requires = [ "shutdown.target" ];
    after = [ "shutdown.target" ];

    serviceConfig = {
      ExecStart = "${rcloneCleanupScript}/bin/rclone-cleanup";
      Type = "oneshot";
    };
  };
}
