{ pkgs, ... }: {
  imports = [
    ./vscodium.nix
    ./android.nix
    ./jetbrains.nix
    ./lazygit.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc
    kitty

    jetbrains.jdk
  ];
}
