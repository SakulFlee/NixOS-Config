{ config, pkgs, lib, inputs, ... }: {
  imports = [ inputs.hermes-agent.nixosModules.default ];

  sops.secrets."hermes-env" = {};

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    package = (inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default).override {
      extraPythonPackages = [
        (pkgs.python312Packages.ddgs.overrideAttrs (old: {
          dontCheckRuntimeDeps = true;
          doInstallCheck = false;
          propagatedBuildInputs = lib.filter
            (p: p.pname != "click")
            (old.propagatedBuildInputs or []);
          passthru = (old.passthru or {}) // {
            requiredPythonModules = lib.filter
              (p: p.pname != "click")
              (old.passthru.requiredPythonModules or []);
          };
        }))
      ];
    };

    environmentFiles = [ config.sops.secrets."hermes-env".path ];

    authFile = pkgs.writeText "auth.json" "{}";

    settings = {
      model = {
        provider = "opencode-go";
        default = "deepseek-v4-flash";
      };

      terminal.backend = "local";
      terminal.cwd = "/var/lib/hermes/workspace";
      toolsets = [ "all" ];

      approvals.mode = "smart";

      compression = {
        enabled = true;
        threshold = 0.85;
      };

      messaging.discord.enabled = true;

      matrix = {
        require_mention = false;
        auto_thread = true;
        session_scope = "room";
        e2ee_mode = "optional";
      };
    };
  };

  nix.settings.max-jobs = 1;

  environment.systemPackages = with pkgs; [
    ripgrep
    ffmpeg
  ];
}
