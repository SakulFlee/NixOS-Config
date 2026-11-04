{ config, pkgs, ... }: {
  xdg.configFile."nvim" = {
    source = ./.;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    # image.nvim is configured with the `magick_cli` processor, so it only
    # needs the ImageMagick CLI. The `magick` Lua rock (and thus luarocks)
    # is not required and should not be installed here.
    extraPackages = with pkgs; [
      imagemagick
      ghostscript
    ];
  };
}
