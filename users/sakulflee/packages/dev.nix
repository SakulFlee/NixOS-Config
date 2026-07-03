{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc

    vscode-runner # Open VSCode workspaces from KDE 
  ];

  programs.vscodium = {
    enable = true;
    profiles.main = {
      extensions = [
        bbenoist.nix         # Nix syntax highlighting
      ];
    };
  };
}

