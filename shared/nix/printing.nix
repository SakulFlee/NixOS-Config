{ pkgs, ...}:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      # CANON printer drivers
      cnijfilter2

      # For file conversion
      ghostscript

      # Standard open-source drivers
      gutenprint

      # Fallback
      cups-filters
    ];

    browsed.enable = false;
  };
}
