{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc

    vscode-runner # Open VSCode workspaces from KDE 
  ];

  programs.vscodium = {
    enable = true;
    
    userSettings = {
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
    };

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix         # Nix syntax highlighting
      jnoortheen.nix-ide   # Nix language server support
      vscodevim.vim        # Vim emulation
    ];
  };
}

