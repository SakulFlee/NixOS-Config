{ pkgs, lib, ... }:
let
  version = "0.2.1";

  # The AMD RX 9070 build supports Navi 48 (gfx1201) and Navi 44 / RX 9060 XT (gfx1200).
  src = pkgs.fetchurl {
    url = "https://github.com/Niko1221/Strata/releases/download/v${version}/Strata-${version}-linux-amd-rx9070.AppImage";
    hash = "sha256-C8oqCZ9Qbh041C1x1Vxwnibzejx+J2ubXFPnkya/NPo=";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Niko1221/Strata/v${version}/apps/desktop/src-tauri/icons/icon.png";
    hash = "sha256-OyYFC+pkU1aqP62YzE9C3DWsCf+8V7lIVjn8Axtrl7E=";
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "strata";
    desktopName = "Strata";
    exec = "strata-gui";
    icon = "strata";
    comment = "Local AI, tuned to one model";
    categories = [
      "Development"
      "Utility"
    ];
  };

  # Keep the GUI's binary separate from the `strata` CLI so both can be
  # installed at once; the desktop entry below still launches the GUI.
  strata-gui = pkgs.appimageTools.wrapType2 {
    pname = "strata-gui";
    inherit version src;

    # The bundled Python looks for /etc/ssl/cert.pem or a hashed CA directory,
    # neither of which exists here, so point it at the NixOS trust store.
    extraBwrapArgs = [
      "--setenv"
      "SSL_CERT_FILE"
      "/etc/ssl/certs/ca-certificates.crt"
    ];

    extraInstallCommands = ''
      install -Dm644 ${desktopItem}/share/applications/strata.desktop \
        $out/share/applications/strata.desktop
      install -Dm644 ${icon} \
        $out/share/icons/hicolor/256x256/apps/strata.png
    '';

    meta = {
      description = "Local AI inference app with an OpenAI/Anthropic-compatible API";
      homepage = "https://github.com/Niko1221/Strata";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "strata-gui";
    };
  };
in
{
  environment.systemPackages = [ strata-gui ];
}
