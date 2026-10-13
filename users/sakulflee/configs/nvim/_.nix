{ config, pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };
}
