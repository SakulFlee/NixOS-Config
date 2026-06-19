{ inputs, pkgs, ... }: {
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./ktrashrc.nix
    ./workspace.nix
    ./desktop.nix
    ./panels.nix
    ./shortcuts.nix
    ./cursor.nix
    ./widgets.nix
  ];

  programs.plasma.enable = true;
}
