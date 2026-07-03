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
        Swellaby.vscode-rust-test-adapter

        # Nix
        bbenoist.nix
        jnoortheen.nix-ide
      ];
    };
  };
}

