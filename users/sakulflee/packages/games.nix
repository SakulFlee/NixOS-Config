{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Proton manager
    protonplus
  ];
}

