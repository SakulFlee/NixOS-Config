{ pkgs, ... }:
{
  hardware.openrazer = {
    enable = true;
    users = [ "sakulflee" ];
    keyStatistics = true;
  };

  environment.systemPackages = with pkgs; [
    razergenie
    razer-cli
  ];
}
