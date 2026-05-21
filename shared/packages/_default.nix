{ pkgs, ... }: {
  imports = [
    ./_allowUnfree.nix
  ];

  environment.systemPackages = with pkgs; [
    neovim
    curl
    git
    firefox
  ];
}
