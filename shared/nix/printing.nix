{ pkgs, ...}:
{
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];

    browsed.enable = true;
  };
}
