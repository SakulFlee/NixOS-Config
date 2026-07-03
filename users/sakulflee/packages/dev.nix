{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc

    vscode-runner # Open VSCode workspaces from KDE 
  ];

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
      };

      extensions = with pkgs.vscode-extensions; [
        # General
        fill-labs.dependi
        hbenl.vscode-test-explorer
        ms-vscode.test-adapter-converter
        vadimcn.vscode-lldb

        # Git tools
        phil294.git-log--graph
        donjayamanne.githistory

        # AI
        continue.continue
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
      ];
    };
  };
}

