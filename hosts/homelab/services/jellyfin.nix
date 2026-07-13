{ config, pkgs, ... }: {
  services.jellyfin = {
    enable = true;
  };

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/jellyfin" ];
  };
}
