{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    config = {
      config = ./waybar/config.jsonc;
      style = ./waybar/style.css;
    };
  };
}
