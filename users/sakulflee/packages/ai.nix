{ pkgs, ... }: {
  home.packages = with pkgs; [
    ollama
    lmstudio
    opencode
    opencode-desktop
  ];
}
