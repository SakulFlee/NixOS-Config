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
      };

      extensions = with pkgs.vscode-extensions; [
        # General
        fill-labs.dependi
        hbenl.vscode-test-explorer

        # Rust
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          mktid = "swellaby.vscode-rust-test-adapter";
          name = "vscode-rust-test-adapter";
          publisher = "swellaby";
          version = "0.11.1";
          sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        })

        # Nix
        bbenoist.nix
        jnoortheen.nix-ide
      ];
    };
  };
}

