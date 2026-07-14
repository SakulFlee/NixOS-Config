{ ... }: {
  imports = [
    ./sops.nix
    ./restic.nix
    ./auto-update.nix
    ./technitium.nix
  ];
}
