{ ... }: {
  imports = [
    ./gc.nix
    ./boot-loader.nix
    ./experimental-features.nix
    ./fonts.nix
    ./gpg.nix
    ./home-manager.nix
    ./kernel.nix
    ./locale.nix
    #    ./mount-nas.nix
    ./nixpkgs-unfree.nix
    ./printing.nix
    ./sops.nix
    ./ssh.nix
    ./system-packages.nix
    ./system-state.nix
    ./wayland.nix
    ./zram.nix
    #    ./wireguard.nix
    ./wheel.nix
    ./llama-swap.nix
    ./dbus.nix
    ./avahi.nix
    ./flatpak.nix
    ./incus-client.nix
    ./kde-plasma.nix
    ./sddm.nix
    ./sdcard.nix
    ./auto-update.nix
    ./srv.nix
    ./gvfs.nix
    ./trash.nix
  ];
}
