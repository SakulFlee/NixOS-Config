{ ... }: {
  services.jellyfin = {
    enable = true;
  };

  # Jellyfin needs access to /dev/dri/renderD128 for AMD VAAPI HW transcoding
  users.users.jellyfin.extraGroups = [ "video" "render" ];

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/jellyfin" ];
  };
}
