{ ... }: {
  imports = [
    ../gc.nix
    ./plasma-manager/_.nix
    ./autostart.nix
    ./nixvim/_.nix
    ./rust.nix
  ];
}

