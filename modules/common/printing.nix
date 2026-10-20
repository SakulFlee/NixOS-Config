{ pkgs, ... }:
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

  environment.systemPackages = with pkgs; [
    # Scanning
    kdePackages.skanpage
  ];

  hardware.printers = {
    ensurePrinters = [
      {
        name = "ET-3960_Series";
        location = "Home";

        deviceUri = "dnssd://EPSON%20ET-3950%20Series._ipp._tcp.local/?uuid=cfe92100-67c4-11d4-a45f-5805d90f2ee2";
        model = "everywhere";

        ppdOptions = {
          media = "a4";
          sides = "two-sided-long-edge";
        };
      }
    ];
    ensureDefaultPrinter = "ET-3960_Series";
  };
}
