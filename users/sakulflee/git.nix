{ pkgs, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "@SakulFlee | Lukas Weber";
      user.email = "dev@sakul-flee.de";

      gpg.program = "${pkgs.gnupg}/bin/gpg";
      signing.key = "0A96C9AA72DB019DE171E7F77F0C6AF1F56A9E05";
      signing.signByDefault = true;
      signing.format = "openpgp";
    };
  };
}
