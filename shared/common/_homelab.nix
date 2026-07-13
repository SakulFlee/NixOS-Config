{ ... }: {
  imports = [
    ./gc.nix
    ./boot-loader.nix
    ./experimental-features.nix 
    ./fonts.nix
    ./gpg.nix
    ./kernel.nix
    ./locale.nix
    ./mount-nas.nix
    ./nixpkgs-unfree.nix
    ./sops.nix
    ./ssh.nix
    ./system-packages.nix
    ./system-state.nix
    ./zram.nix
    ./zsh.nix
    ./wireguard.nix
    ./wheel.nix
    ./dbus.nix
    ./nixos-auto-updater.nix
  ];
}
