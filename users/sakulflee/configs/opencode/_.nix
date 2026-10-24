{ inputs, pkgs, ... }:
let
  opencodePkgs = inputs.nixpkgs-opencode.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  remote = pkgs.writeShellApplication {
    name = "opencode-remote";
    runtimeInputs = [
      opencodePkgs.opencode
      pkgs.coreutils
    ];
    text = ''
      if [ ! -r /run/secrets/opencode_server_password ]; then
        echo "opencode-remote: /run/secrets/opencode_server_password is not readable" >&2
        exit 1
      fi

      OPENCODE_SERVER_PASSWORD="$(cat /run/secrets/opencode_server_password)"
      export OPENCODE_SERVER_PASSWORD

      exec opencode --server https://opencode.sakul-flee.de "$@"
    '';
  };
in
{
  home.packages = [
    opencodePkgs.opencode
    opencodePkgs.opencode-desktop
    remote
  ];

  home.file.".config/opencode/opencode.jsonc".source = ./opencode.jsonc;
}
