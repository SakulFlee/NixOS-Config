{ pkgs, ... }:
{
  services.akonadi = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.kdepim-runtime
  ];
}
