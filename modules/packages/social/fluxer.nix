{ pkgs, ... }:
let
  fluxerPackages = pkgs.callPackage ./fluxer/packages.nix { };
in
{
  # Fluxer's own Linux builds are not in nixpkgs, so both channels are
  # packaged locally from the official tarballs.
  environment.systemPackages = [
    fluxerPackages.fluxer
    fluxerPackages.fluxer-canary
  ];
}
