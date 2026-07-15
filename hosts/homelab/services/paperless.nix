{ config, pkgs, lib, ... }: {
  services.paperless = {
    enable = true;
    # Bind to localhost; Caddy reverse proxies from the domain
    address = "127.0.0.1";
    port = 28981;

    # Use PostgreSQL (already running on HomeLab)
    database.createLocally = true;

    # Enable Tika + Gotenberg for Office docs and email files
    configureTika = true;

    # OCR German and English documents
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      # Ignore macOS metadata files in consumption
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
    };

    # Auto-export documents nightly for backup purposes
    exporter.enable = true;
  };

  # Backup paperless data directory to NAS via restic
  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/paperless" ];
  };
}
