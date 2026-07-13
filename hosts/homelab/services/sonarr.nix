{ ... }: {
  services.sonarr = {
    enable = true;
  };

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/sonarr" ];
  };
}
