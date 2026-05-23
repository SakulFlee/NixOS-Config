{ pkgs, ... }: {
  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ../home-manager/shared/kde-plasma6.nix
    ];
    home.stateVersion = "25.11";
  };
}
