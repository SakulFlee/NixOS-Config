{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.kdepim-runtime
    kdePackages.akonadi
    kdePackages.akonadi-mime
    kdePackages.akonadi-search
    kdePackages.akonadi-calendar
    kdePackages.akonadi-calendar-tools
    kdePackages.akonadi-contacts
    kdePackages.akonadi-import-wizard
    kdePackages.mbox-importer
  ];
}
