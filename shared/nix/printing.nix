{ pkgs, ...}:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      # CANON printer drivers
      cnijfilter2

      # For file conversion
      ghostscript

      # Fallback
      cups-filters
    ];

    browsed.enable = true;
  };
}
