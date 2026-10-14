{ ... }: {
  imports = [
    ../common/gc.nix
    ./plasma-manager/_.nix
    ./packages/_.nix
    ./autostart.nix
    ./neovim/_.nix
    ./rust.nix
    ./direnv.nix
  ];
}
