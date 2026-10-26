{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libappindicator,
  libdrm,
  libgbm,
  libnotify,
  libpulseaudio,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxkbfile,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  nspr,
  nss,
  pango,
  pipewire,
  systemdLibs,
  wayland,
  xdg-utils,
  zlib,
}:

let
  # Official prebuilt Linux tarballs, one per channel:
  #   https://pkgs.fluxer.com/desktop/<channel>/linux/x64/<version>/tar_gz
  #
  # The version and hash can be updated from:
  #   https://pkgs.fluxer.com/desktop/<channel>/linux/x64/latest/latest.json
  mkFluxer =
    {
      pname,
      version,
      hash,
      channel,
      srcName,
      displayName,
      binaryName,
      desktopId,
      iconName,
      comment,
    }:
    let
      desktopItem = makeDesktopItem {
        name = desktopId;
        desktopName = displayName;
        genericName = "Instant Messenger";
        comment = comment;
        exec = "${binaryName} %U";
        tryExec = binaryName;
        icon = iconName;
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        keywords = [
          "chat"
          "im"
          "messaging"
          "messenger"
          "voip"
          "voice"
          "video"
          "call"
        ];
        mimeTypes = [ "x-scheme-handler/fluxer" ];
        startupNotify = true;
        startupWMClass = desktopId;
        singleMainWindow = true;
        extraConfig = {
          "X-GNOME-UsesNotifications" = "true";
        };
        actions = {
          open-settings = {
            name = "Open Settings";
            exec = "${binaryName} --fluxer-task=open-settings %U";
          };
          new-dm = {
            name = "New Direct Message";
            exec = "${binaryName} --fluxer-task=new-dm %U";
          };
        };
      };
    in
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version;

      src = fetchurl {
        url = "https://pkgs.fluxer.com/desktop/${channel}/linux/x64/${version}/tar_gz";
        inherit hash;
      };

      sourceRoot = "${srcName}-${version}-linux-x64";

      nativeBuildInputs = [
        autoPatchelfHook
        copyDesktopItems
        makeWrapper
      ];

      buildInputs = [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        dbus
        expat
        fontconfig
        freetype
        gdk-pixbuf
        glib
        gtk3
        libGL
        libappindicator
        libdrm
        libgbm
        libnotify
        libpulseaudio
        libsecret
        libxkbcommon
        nspr
        nss
        pango
        pipewire
        systemdLibs
        wayland
        libx11
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxrandr
        libxrender
        libxscrnsaver
        libxtst
        libxcb
        libxkbfile
        libxshmfence
        zlib
        (lib.getLib stdenv.cc.cc)
      ];

      # Chromium loads several of these with dlopen(), so they are not
      # discoverable from DT_NEEDED alone. Prepending them to the executable's
      # RUNPATH makes those lookups work for the main and child processes.
      runtimeDependencies = map lib.getLib [
        libappindicator
        libGL
        libnotify
        libpulseaudio
        libsecret
        fontconfig
        freetype
        wayland
        libxscrnsaver
      ];

      # Electron ships prebuilt binaries; stripping them can break crash
      # reporting and symbolization.
      dontStrip = true;

      desktopItems = [ desktopItem ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/fluxer
        cp -a . $out/lib/fluxer
        chmod -R u+w $out/lib/fluxer

        mkdir -p $out/bin
        makeWrapper $out/lib/fluxer/${binaryName} $out/bin/${binaryName} \
          --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
          --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}"

        for size in 16 24 32 48 64 128 256 512; do
          install -Dm644 resources/icons/''${size}x''${size}.png \
            $out/share/icons/hicolor/''${size}x''${size}/apps/${iconName}.png
        done

        runHook postInstall
      '';

      meta = {
        description = "Free and open source instant messaging and VoIP chat app";
        homepage = "https://fluxer.app";
        license = lib.licenses.agpl3Plus;
        mainProgram = binaryName;
        platforms = [ "x86_64-linux" ];
        sourceProvenance = with lib.sourceTypes; [
          binaryNativeCode
          binaryBytecode
        ];
      };
    });
in
{
  fluxer = mkFluxer {
    pname = "fluxer";
    version = "2026.1025.12517";
    hash = "sha256-nbms8MCZxhrlg859MbsKZxoUix2LFtYcbR6yuvzFExg=";
    channel = "stable";
    srcName = "Fluxer";
    displayName = "Fluxer";
    binaryName = "fluxer";
    desktopId = "app.fluxer.FluxerDesktop";
    iconName = "fluxer";
    comment = "Instant messaging and VoIP";
  };

  fluxer-canary = mkFluxer {
    pname = "fluxer-canary";
    version = "2026.1025.12532";
    hash = "sha256-eV2NHOgc6o7oFeoQhV8RlXkSreYqTjVB06VSNMLBtCg=";
    channel = "canary";
    srcName = "Fluxer-Canary";
    displayName = "Fluxer Canary";
    binaryName = "fluxer-canary";
    desktopId = "app.fluxer.FluxerDesktopCanary";
    iconName = "fluxer-canary";
    comment = "Canary build of Fluxer";
  };
}
