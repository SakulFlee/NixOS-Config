{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "@SakulFlee | Lukas Weber";
      user.email = "dev@sakul-flee.de";

      signing = {
        key = "0x7F0C6AF1F56A9E05";
        signByDefault = true;
      };
    };
  };
}
