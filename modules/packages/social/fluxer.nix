{ pkgs, ... }:
let
  fluxerPackages = pkgs.callPackage ./fluxer/packages.nix { };
in
{
  # Fluxer's official Linux build is not in nixpkgs, so it is packaged
  # locally from the official tarball.
  environment.systemPackages = [
    fluxerPackages.fluxer
  ];
}
