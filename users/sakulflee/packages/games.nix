{ pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    # Proton manager
    unstable.protonplus
    # FFXIV
    xivlauncher
    # Minecraft
    prismlauncher
  ];
}

