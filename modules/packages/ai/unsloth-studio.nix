{ pkgs, lib, ... }:
let
  # Unsloth's first-run installer downloads its own Python environment and
  # llama.cpp bundle. NixOS cannot execute those generic glibc binaries, so
  # point it at Nix-provided tools instead:
  #   - uv/python313 create the venv without downloading a Python build
  #   - llama-cpp-rocm supplies llama-server for GGUF inference
  #   - rocminfo/amdsmi let the installer detect the AMD GPU and pick ROCm torch
  #
  # This host has a Radeon RX 9060 XT (gfx1200) plus a Ryzen iGPU (gfx1036).
  # Naming the discrete GPU keeps Unsloth on the ROCm wheel index instead of
  # falling back to CPU torch when it sees two different architectures.
  llama-cpp = pkgs.llama-cpp-rocm;
  rocmGfxArch = "gfx1200";

  unsloth-studio = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "unsloth-studio";
    version = "0.1.915-beta";

    src = pkgs.fetchurl {
      url = "https://github.com/unslothai/unsloth/releases/download/v${finalAttrs.version}/Unsloth-Desktop-Ubuntu.deb";
      hash = "sha256-q8t2YxLKOkc7FwWSv2lfykVmZC6XIZqd6sStTm5h4I0=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      wrapGAppsHook3
      makeWrapper
    ];

    buildInputs = with pkgs; [
      webkitgtk_4_1
      gtk3
      libsoup_3
      libappindicator-gtk3
      gdk-pixbuf
      cairo
      pango
      glib
      dbus
      gsettings-desktop-schemas
    ];

    runtimeDependencies = map lib.getLib (
      with pkgs;
      [
        webkitgtk_4_1
        gtk3
        libsoup_3
        libappindicator-gtk3
        gdk-pixbuf
        glib
      ]
    );

    unpackPhase = ''
      runHook preUnpack
      ar x $src
      tar -xzf data.tar.gz
      runHook postUnpack
    '';

    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      install -Dm755 usr/bin/unsloth-studio $out/bin/unsloth-studio
      install -Dm755 usr/lib/Unsloth/install.sh $out/lib/Unsloth/install.sh

      mkdir -p $out/share
      cp -r usr/share/icons $out/share/icons
      install -Dm644 usr/share/applications/Unsloth.desktop \
        $out/share/applications/Unsloth.desktop
      sed -i \
        -e 's/^Categories=$/Categories=Development;Utility;/' \
        -e 's/^Comment=.*/Comment=Local UI to run and train LLMs and diffusion models/' \
        $out/share/applications/Unsloth.desktop

      # The desktop app runs this same script in --tauri mode on first launch.
      # Expose it so the environment can be provisioned headlessly.
      printf '#!%s\nexec %s %s --tauri "$@"\n' \
        "${pkgs.bash}/bin/bash" \
        "${pkgs.bash}/bin/bash" \
        "$out/lib/Unsloth/install.sh" \
        > $out/bin/unsloth-studio-install
      chmod +x $out/bin/unsloth-studio-install

      runHook postInstall
    '';

    postFixup = ''
      wrapUnsloth() {
        # The ROCm torch wheels are manylinux builds: they need the Nix
        # libstdc++/zlib/openssl/ffmpeg stack, plus the host GPU userspace,
        # or `import torch` fails before it can enumerate the GPU.
        #
        # Nix owns the runtime versions. Leaving Unsloth's updater enabled
        # makes it try to write .bin.install.lock into the read-only store.
        #
        # Prefer Hugging Face; Unsloth otherwise auto-selects ModelScope in
        # some regions, which hides HF models from the Hub until changed.
        wrapProgram "$1" \
          --prefix PATH : ${
            lib.makeBinPath (
              (with pkgs; [
                uv
                python313
                curl
                unzip
                xdg-utils
                bubblewrap
                glib
                desktop-file-utils
              ])
              ++ [
                pkgs.rocmPackages.rocminfo
                pkgs.rocmPackages.amdsmi
              ]
            )
          } \
          --prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath (
              with pkgs;
              [
                stdenv.cc.cc.lib
                zlib
                openssl
                ffmpeg
                nghttp2
              ]
            )
          }:/run/opengl-driver/lib \
          --set-default UV_PYTHON_PREFERENCE only-system \
          --set-default UV_PYTHON_DOWNLOADS never \
          --set-default UNSLOTH_PYTHON 3.13 \
          --set-default UNSLOTH_ROCM_GFX_ARCH ${rocmGfxArch} \
          --set-default UNSLOTH_LOCAL_LLAMA_CPP_DIR ${llama-cpp}/bin \
          --set-default UNSLOTH_DISABLE_UPDATE_CHECK 1 \
          --set-default UNSLOTH_MIRROR_FALLBACK 0 \
          --set-default SSL_CERT_FILE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --set-default NIX_SSL_CERT_FILE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --set-default REQUESTS_CA_BUNDLE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
          --set-default CURL_CA_BUNDLE ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      }

      wrapUnsloth $out/bin/unsloth-studio
      wrapUnsloth $out/bin/unsloth-studio-install
    '';

    meta = {
      description = "Unified web UI for training and running open models locally";
      homepage = "https://unsloth.ai/";
      license = lib.licenses.agpl3Only;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "unsloth-studio";
    };
  });
in
{
  environment.systemPackages = [ unsloth-studio ];
}
