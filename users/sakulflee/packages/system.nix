{ pkgs, ... }: {
  home.packages = with pkgs; [
    deskflow
    rustdesk-flutter
  ];
}
