{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  programs.firefox = {
    enable = true;
  };

  programs.mtr = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
      theme = "robbyrussell";
    };
  };
}
