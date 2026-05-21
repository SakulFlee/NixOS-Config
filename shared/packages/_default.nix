{ pkgs, ... }: {
  imports = [
    ./_allowUnfree.nix
    ./firefox.nix
    ./zsh.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    firefox
  ];
}
