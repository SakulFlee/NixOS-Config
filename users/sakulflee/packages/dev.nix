{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc

    vscode-runner # Open VSCode workspaces from KDE 
  ];

  programs.vscode = {
    enable = true;
    profiles.main = {
      extensions = [
      ];
    };
  };
}

