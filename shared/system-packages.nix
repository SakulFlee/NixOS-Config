{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Core utilities
    neovim
    curl
    git
  ];
}
