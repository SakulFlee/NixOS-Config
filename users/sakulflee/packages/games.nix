{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Proton managers
    protonplus
    protonup-ng
    protonup-qt
    protonup-rs

    # DW Proton for Gacha games
    dwproton-bin

    # GE Proton for other games
    proton-ge-bin
  ];
}

