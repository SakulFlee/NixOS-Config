{ ... }: {
  programs.plasma.configFile."kdeglobals" = {
    General = {
      TerminalApplication = "kitty";
      TerminalService = "kitty.desktop";
    };
  };
}
