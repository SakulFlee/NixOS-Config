{ config, pkgs, ... }: {
  # LazyVim managed config - installed/updated separately
  # Just ensure runtime dependencies are available
  home.packages = with pkgs; [
    ripgrep
    fd
    tree-sitter
    nodejs
  ];
}
