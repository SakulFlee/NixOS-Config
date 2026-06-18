{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Proton managers
    protonplus
    protonup-ng
    protonup-qt
    protonup-rs

    # DW Proton for Gacha games
    (runCommand "dwproton-bin-fixed" {} ''
      mkdir -p $out/bin
      ln -s ${dwproton-bin} $out/bin/dwproton
    '')

    # GE Proton for other games
    proton-ge-bin
  ];
}

