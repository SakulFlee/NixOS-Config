{
  pkgs,
  lib,
  ...
}:
let
  release = "0.2.11";
  version = "0.1.57";

  # The terminal is published as "strata-control" and is versioned separately
  # from the desktop app. It bundles its own Python, but not the engine: the
  # engine is downloaded by `strata launch`/`strata update` for the GPU it finds.
  src = pkgs.fetchurl {
    url = "https://github.com/Niko1221/Strata/releases/download/v${release}/strata-control-${version}-linux-x86_64.tar.gz";
    hash = "sha256-KseM/+5KY4tPMtMCDVqF2ovR0yorEnBdjE+3BrYJTQg=";
  };

  strata-cli-unwrapped = pkgs.runCommandLocal "strata-cli-${version}" { inherit src; } ''
    mkdir -p $out/share/strata
    tar -xzf $src -C $out/share/strata
  '';

  # The archive and the engine it downloads are generic glibc binaries. Run
  # them in an FHS environment instead of patching the bundle, because the
  # engine is fetched into the user's home at runtime and its hashes are
  # checked against the signed release feed.
  strata-cli = pkgs.buildFHSEnv {
    pname = "strata";
    inherit version;

    targetPkgs =
      p:
      with p;
      [
        bash
        cacert
        coreutils
        curl
        findutils
        gnugrep
        gnused
        libxcrypt
        openssl
        pciutils
        procps
        stdenv.cc.cc.lib
        util-linux
        which
        zlib
      ];

    runScript = "${strata-cli-unwrapped}/share/strata/bin/strata";

    meta = {
      description = "Strata Terminal: local AI inference with an OpenAI/Anthropic-compatible API";
      homepage = "https://github.com/Niko1221/Strata";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "strata";
    };
  };
in
{
  environment.systemPackages = [ strata-cli ];
}
