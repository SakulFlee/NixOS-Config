{ ... }: {
  imports = [
    ./_system_state.nix
    ./kernel.nix
    ./language.nix
    ./timezone.nix
    ./home-manager.nix
    ./fonts.nix
    ./packages/_default.nix
  ];
}
