{ pkgs, lib, ... }:
let
  version = "0.2.0-beta";

  # The AMD RX 9070 build supports Navi 48 (gfx1201) and Navi 44 / RX 9060 XT (gfx1200).
  src = pkgs.fetchurl {
    url = "https://github.com/Niko1221/Strata/releases/download/v${version}/Strata-${version}-linux-amd-rx9070.AppImage";
    hash = "sha256-MpO+V3wfbeUgB4CGc5dWAVgKjp5dwwZGpJI5VpKmu3A=";
  };

  icon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Niko1221/Strata/v${version}/apps/desktop/src-tauri/icons/icon.png";
    hash = "sha256-OyYFC+pkU1aqP62YzE9C3DWsCf+8V7lIVjn8Axtrl7E=";
  };

  desktopItem = pkgs.makeDesktopItem {
    name = "strata";
    desktopName = "Strata";
    exec = "strata";
    icon = "strata";
    comment = "Local AI, tuned to one model";
    categories = [
      "Development"
      "Utility"
    ];
  };

  strata = pkgs.appimageTools.wrapType2 {
    pname = "strata";
    inherit version src;

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
      mainProgram = "strata";
    };
  };
in
{
  environment.systemPackages = [ strata ];
}
