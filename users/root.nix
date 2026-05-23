{ pkgs, ... }: {
  home-manager.users.root = { pkgs, ... }: {
    home.stateVersion = "25.11";
  };
}
