{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.fansly-recorder.packages.x86_64-linux.default
  ];
}
