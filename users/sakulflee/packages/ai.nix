{ pkgs, unstable, inputs, ... }: {
  home.packages = with pkgs; [
    (unstable.ollama)
    (unstable.lmstudio)
    opencode
    opencode-desktop
    cursor-cli
    pi-coding-agent
    claude-code
    (inputs.llama-cpp.packages.${pkgs.system}.vulkan)
    llama-swap
  ];
}
