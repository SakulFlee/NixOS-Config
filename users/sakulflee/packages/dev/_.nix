{ pkgs, ... }: {
  imports = [
    ./vscodium.nix
  ]

  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc

    vscode-runner # Open VSCode workspaces from KDE 
  ];
}
