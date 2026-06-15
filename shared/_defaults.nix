{ ... }: {
  imports = [
    ./audio.nix
    ./wayland.nix
    ./kde/_defaults.nix
    ./system-core.nix
    ./system-gc.nix
    ./system-network.nix
    ./system-desktop.nix
    ./system-security.nix
    ./system-packages.nix
    ./system-programs.nix
    ./home-manager.nix
  ];
}
