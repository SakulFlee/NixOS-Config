{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    jupyter-all
  ];
}
