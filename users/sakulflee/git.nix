{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "@SakulFlee | Lukas Weber";
      user.email = "dev@sakul-flee.de";
      user.signingKey = "0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05";
      signing.signByDefault = true;
    };
  };
}
