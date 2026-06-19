{ pkgs, ...}:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      # CANON printer drivers
      cnijfilter2

      # For file conversion
      ghostscript
    ];

    browsed.enable = true;
  };
}
