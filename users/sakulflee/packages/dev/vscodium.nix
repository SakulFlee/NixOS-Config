{ pkgs, ... }: {
  programs.vscodium = {
    enable = true;
    profiles.default = {
      userSettings = {
        "telemetry.telemetryLevel" = "off";
        "update.mode" = "none";
        "workbench.sideBar.location" = "right";
        "workbench.activityBar.iconSizes" = "small";
        "git.enableSmartCommit" = true;
        "git.alwaysSignOff" = true;
        "git.autofetch" = "all";
        "git.confirmSync" = false;
        "files.autoSave" = "onFocusChange";
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'";
        "editor.fontLigatures" = true; # Enables beautiful code arrows (->, ==)
      };

      keybindings = [
        {
          key = "ctrl+ö";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminalProcessSupported";
        }
      ];

      extensions = with pkgs.vscode-extensions; [
        # General
        fill-labs.dependi
        hbenl.vscode-test-explorer
        ms-vscode.test-adapter-converter
        vadimcn.vscode-lldb
        esbenp.prettier-vscode
        redhat.vscode-yaml

        # Git tools
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "asispts";
            name = "neo-git-graph";
            version = "0.4.0";
            sha256 = "sha256-tMd76ZQjiE/3U95/TFrbLG9TgIxpREhrSK/tXMfN2Yk=";
          };
          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ (pkgs.lib.getLib pkgs.stdenv.cc.cc) ];
        })
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "boyan01";
            name = "intelli-git";
            version = "0.0.7";
            sha256 = "sha256-Zl8obCV157FXHQFnPA2kalrXdukxfXUKzbdJ9q6Saq8=";
          };
          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ (pkgs.lib.getLib pkgs.stdenv.cc.cc) ];
        })

        # AI
        kilocode.kilo-code
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "RooVeterinaryInc";
            name = "roo-cline";
            version = "3.54.0";
            sha256 = "sha256-yvltWW1pyzQn8Aw8pgSSaTE1zGufYhqgYiApA6plJzU=";
          };
          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ (pkgs.lib.getLib pkgs.stdenv.cc.cc) ];
        })
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "Continue";
            name = "continue";
            version = "2.1.0";
            arch = "linux-x64";
            sha256 = "sha256-O2L5xTj04tFYRUolBoY7KftNS/qPA5RIkOpL0ar9p38=";
          };
          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ (pkgs.lib.getLib pkgs.stdenv.cc.cc) ];
        })
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "sst-dev";
            name = "opencode";
            version = "0.0.13";
            sha256 = "sha256-6adXUaoh/OP5yYItH3GAQ7GpupfmTGaxkKP6hYUMYNQ=";
          };
        })
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "PrintagaPublishingLLC";
            name = "pilots-studio";
            version = "2.2.0";
            sha256 = "sha256-hIV4P6stGon3Jp3A+PJ5LkWsiCA6B795uKniDQ+rYDQ=";
          };
        })
        
        # Rust
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "Swellaby";
            name = "vscode-rust-test-adapter";
            version = "0.11.0";
            sha256 = "sha256-IgfcIRF54JXm9l2vVjf7lFJOVSI0CDgDjQT+Hw6FO4Q=";
          };
        })

        # Nix
        bbenoist.nix
        jnoortheen.nix-ide

        # Terraform
        hashicorp.terraform

        # Markdown & Typst
        myriad-dreamin.tinymist
        tomoki1207.pdf
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "MermaidChart";
            name = "vscode-mermaid-chart";
            version = "2.7.2";
            sha256 = "sha256-hXJPKvmXpJi54O6xSJFR20jHOS6hzyPGFTu7JDSKe2s=";
          };
        })
      ];
    };
  };
}

