{ ... }: {
  imports = [
    ./system-core.nix
    ./system-gc.nix
    ./system-network.nix
    ./system-desktop.nix
    ./system-security.nix
    ./system-packages.nix
    ./system-programs.nix
    ./packages/files.nix
    ./packages/development.nix
    ./home-manager.nix
  ];
}
