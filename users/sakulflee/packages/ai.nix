{ pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    (unstable.ollama)
    (unstable.lmstudio)
    opencode
    opencode-desktop
    cursor-cli
    pi-coding-agent
    claude-code
    (unstable.llama-cpp-vulkan)
  ];
}
