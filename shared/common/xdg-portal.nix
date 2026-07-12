{ pkgs, ...}:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
    config =  {
      common = {
        default = [ "kde" ];
      };
    };
  };
}
