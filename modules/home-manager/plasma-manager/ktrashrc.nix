{ lib, ... }:
let
  # KIO keys each trash policy by the trash directory, not the mount point:
  # /home uses the home trash, every other volume uses $mount/.Trash-<uid>.
  trashDirs = [
    "/home/sakulflee/.local/share/Trash"
    "/.Trash-1000"
    "/mnt/nvme/.Trash-1000"
    "/mnt/ssd/.Trash-1000"
  ];

  policy = {
    "UseSizeLimit" = true;
    "Percent" = 10;
    "LimitReachedAction" = 0;
    "UseTimeLimit" = true;
    "Days" = 14;
  };
in
{
  programs.plasma.configFile."ktrashrc" = lib.genAttrs trashDirs (_: policy);
}
