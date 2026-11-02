{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ocrmypdf
  ];
}
