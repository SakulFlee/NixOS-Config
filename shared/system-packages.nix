{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Core utilities
    neovim
    curl
    git

    # Infrastructure
    docker
    xorg.xauth
  ];
}
