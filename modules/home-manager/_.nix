{ ... }: {
  imports = [
    ../common/gc.nix
    ./plasma-manager/_.nix
    ./packages/_.nix
    ./autostart.nix
    ./desktop-entries.nix
    ./neovim/_.nix
    ./rust.nix
    ./direnv.nix
  ];
}
