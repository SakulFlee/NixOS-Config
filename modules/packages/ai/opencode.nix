{ inputs, pkgs, ... }:
let
  opencodePkgs = inputs.nixpkgs-opencode.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = [
    opencodePkgs.opencode
    opencodePkgs.opencode-desktop
  ];
}
