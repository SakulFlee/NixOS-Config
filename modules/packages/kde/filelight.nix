{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kdePackages.filelight
  ];
}
