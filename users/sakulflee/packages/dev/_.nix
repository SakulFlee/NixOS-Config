{ pkgs, ... }: {
  imports = [
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc

    jetbrains.clion
    jetbrains.datagrip
    jetbrains.dataspell
    jetbrains.gateway
    jetbrains.idea
    jetbrains.rust-rover
    jetbrains.mono
    jetbrains.jdk

    vscode-runner # Open VSCode workspaces from KDE 
  ];
}
