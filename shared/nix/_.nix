{ ... }: {
  imports = [
    ./sops.nix
    ./printing.nix
    ./touchpad.nix
    ./audio.nix
    ./wayland.nix
    ./kde/_.nix
    ./system-core.nix
    ./nix-gc.nix
    ./system-network.nix
    ./system-security.nix
    ./system-programs.nix
    ./home-manager.nix
    ./nas.nix
    ./nixpkgs-unfree.nix
    ./zsh.nix
    ./system-state.nix
  ];
}
