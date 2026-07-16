{ ... }: {
  programs.ssh = {
    enable = true;
    settings = {
      "*" = {
        setEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };
}