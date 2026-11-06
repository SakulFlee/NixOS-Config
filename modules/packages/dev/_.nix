{ ... }: {
  imports = [
    ./zed.nix
    ./lazygit.nix
    ./neovim.nix
    ./git.nix
    ./gpg.nix
    ./nixfmt.nix
    ./clang.nix
    ./gcc.nix
    ./docker.nix
    ./waydroid.nix
    ./quickemu.nix
    ./jupyter.nix
    ./qwen-code.nix
  ];
}
