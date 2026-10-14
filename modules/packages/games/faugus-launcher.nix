{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.faugus-launcher
  ];
}
