{ ... }: {
  services.radarr = {
    enable = true;
  };

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/radarr" ];
  };
}
