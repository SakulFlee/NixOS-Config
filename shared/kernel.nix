{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackage_latest;
}
