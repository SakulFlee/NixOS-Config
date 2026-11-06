{ pkgs, ... }:
{
  hardware.openrazer = {
    enable = true;
    users = [ "sakulflee" ];
    keyStatistics = true;
  };
}
