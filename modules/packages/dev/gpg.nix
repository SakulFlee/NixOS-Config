{ pkgs, ... }: {
  programs.gnupg.enable = true;
  environment.systemPackages = with pkgs; [
    gnupg
  ];
}
