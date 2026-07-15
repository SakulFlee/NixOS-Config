{ pkgs, lib, ... }:

let
  # Jellyfin's ffmpeg generates Vulkan init flags that conflict with
  # scale_vaapi on AMD RADV. This wrapper invokes the real ffmpeg
  # directly, bypassing the default wrapper that would add those flags.
  ffmpeg-wrapper = pkgs.writeShellScriptBin "ffmpeg" ''
    exec ${lib.getBin pkgs.jellyfin-ffmpeg}/bin/ffmpeg "$@"
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
