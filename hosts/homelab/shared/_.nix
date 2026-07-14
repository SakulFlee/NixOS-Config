{ ... }: {
  imports = [
    ./sops.nix
    ./restic.nix
    ./auto-update.nix
    ./dns.nix
  ];
}
