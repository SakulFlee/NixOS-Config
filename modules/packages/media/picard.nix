{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    picard
    picard-tools
  ];
}
