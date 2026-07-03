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
        "files.autoSave" = "onFocusChange";
      };

      extensions = with pkgs.vscode-extensions; [
        # General
        fill-labs.dependi
        hbenl.vscode-test-explorer
        ms-vscode.test-adapter-converter
        vadimcn.vscode-lldb

        # AI
        sst-dev.opencode
        PrintagaPublishingLLC.pilots-studio
        Continue.continue

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

