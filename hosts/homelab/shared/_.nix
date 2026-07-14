{ ... }: {
  imports = [
    ./sops.nix
    ./restic.nix
    ./auto-update.nix
    ./dns.nix
    ./mount-nas.nix
  ];
}
