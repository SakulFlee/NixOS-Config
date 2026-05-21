{ config, pkgs, lib, home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
