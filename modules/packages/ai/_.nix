{ ... }: {
  imports = [
    ./llama-cpp.nix
    ./llama-swap.nix
    ./opencode.nix
    ./unsloth-studio.nix
    ./lmstudio.nix
    ./comfyui.nix
    ./strata-cli.nix
    ./strata.nix
    ./herdr.nix
  ];
}
