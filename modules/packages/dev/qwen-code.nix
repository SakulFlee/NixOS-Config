{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    qwen-code
  ];
}
