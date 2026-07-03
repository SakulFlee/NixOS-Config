{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wl-clipboard
    renderdoc
  ];

  programs.vscode = {
    enable = true;
    profiles.main = {
      extensions = [
      ];
    };
  };
}

