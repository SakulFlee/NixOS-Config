{ lib, pkgs, ... }: {
  # Default kernel is gaming focused (ZEN)
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
}
