{ ... }: {
  imports = [
    ./envs.nix
    ./plasma.nix
    ./xdg-portal.nix
    ./sddm.nix
    ./kde-patch.nix
  ];
}

