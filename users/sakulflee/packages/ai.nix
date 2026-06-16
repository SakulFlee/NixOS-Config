{ pkgs, ... }: {
  home.packages = with pkgs; [
    ollama
    lmstudio
  ];
}
