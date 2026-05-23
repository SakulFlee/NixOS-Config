{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "@SakulFlee | Lukas Weber";
      user.email = "dev@sakul-flee.de";
    };
  };

  programs.zsh = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
  };
}
