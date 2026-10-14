{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libreoffice
    libreoffice-collabora
  ];
}
