{ ... }: {
  # FreeDesktop trash for the root volume (/).
  # /home is a separate volume, so files under / (e.g. /etc/nixos) have no
  # writable trash dir. Without this, KIO, gio and trash-cli all refuse with
  # "A trash folder could not be found or created for this location", which is
  # what breaks "delete to trash" from within NeoVim (snacks explorer).
  # NOTE: the directory name must match the user's uid (1000).
  systemd.tmpfiles.rules = [
    "d /.Trash-1000 0700 sakulflee users - -"
  ];
}
