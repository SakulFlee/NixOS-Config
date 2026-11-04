{ config, pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    extraLuaPackages = luaPkgs: [
      luaPkgs.magick
    ];
    extraPackages = with pkgs; [
      imagemagick
      ghostscript
      luarocks
    ];
  };
}
