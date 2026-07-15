{ pkgs, lib, ... }:

let
  # Jellyfin generates FFmpeg commands with -init_hw_device vulkan and
  # -filter_hw_device vk which conflicts with the scale_vaapi filter on
  # AMD RADV. This wrapper strips those flags so only DRM+VAAPI are used.
  ffmpeg-wrapper = pkgs.writeShellScriptBin "ffmpeg" ''
    exec ${lib.getBin pkgs.jellyfin-ffmpeg}/bin/ffmpeg \
      -init_hw_device drm=dr:/dev/dri/renderD128 \
      -init_hw_device vaapi=va@dr "$@"
  '';
in {
  services.jellyfin = {
    enable = true;
    # Swap the bundled ffmpeg with our Vulkan-free wrapper
    package = pkgs.jellyfin.override {
      jellyfin-ffmpeg = ffmpeg-wrapper;
    };

    # Manage encoding config from NixOS
    forceEncodingConfig = true;

    hardwareAcceleration = {
      enable = true;
      type = "vaapi";
      device = "/dev/dri/renderD128";
    };

    transcoding = {
      enableHardwareEncoding = true;
      enableToneMapping = false;
    };
  };

  # Jellyfin needs access to /dev/dri/renderD128 for AMD VAAPI HW transcoding
  users.users.jellyfin.extraGroups = [ "video" "render" ];

  services.homelab-restic = {
    enable = true;
    paths = [ "/var/lib/jellyfin" ];
  };
}
