{ ... }: {
  imports = [
    ../common/gc.nix
    ./plasma-manager/_.nix
    ./autostart.nix
    ./neovim/_.nix
    ./rust.nix
    ./direnv.nix
  ];
}

