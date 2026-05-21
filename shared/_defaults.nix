{ ... }: {
  imports = [
    ./_system_state.nix
    ./kernel.nix
    ./language.nix
    ./timezone.nix
    ./home-manager.nix
    ./packages/_default.nix
  ];
}
