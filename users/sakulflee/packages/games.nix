{ pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    # Proton manager
    unstable.protonplus
  ];
}

