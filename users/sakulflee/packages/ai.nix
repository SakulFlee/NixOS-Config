{ pkgs, ... }: {
  home.packages = with pkgs; [
    ollama
    lmstudio
    opencode
    opencode-desktop
    cursor-cli
    pi-coding-agent
    claude-code
    llama-cpp-vulkan
  ];
}
