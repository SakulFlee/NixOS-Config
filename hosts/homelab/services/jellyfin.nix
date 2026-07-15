{ pkgs, lib, ... }:

let
  # Jellyfin generates FFmpeg commands with -init_hw_device vulkan and
  # -filter_hw_device vk which conflicts with the scale_vaapi filter on
  # AMD RADV. This wrapper strips those flags so only DRM+VAAPI are used.
  ffmpeg-wrapper = pkgs.writeShellScriptBin "jellyfin-ffmpeg" ''
    exec ${lib.getBin pkgs.jellyfin-ffmpeg}/bin/ffmpeg \
      -init_hw_device drm=dr:/dev/dri/renderD128 \
      -init_hw_device vaapi=va@dr "$@"
  '';

  # Override the jellyfin package to point --ffmpeg at our wrapper
  jellyfin-custom = pkgs.jellyfin.overrideAttrs (old: {
    installPhase = (old.installPhase or "") + ''
      # Replace the hardcoded ffmpeg path in the wrapper with our wrapper
      substituteInPlace $out/bin/jellyfin \
        --replace-fail "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg" "${ffmpeg-wrapper}/bin/jellyfin-ffmpeg"
    '';
  });
in {
  services.jellyfin = {
    enable = true;
    package = jellyfin-custom;

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
