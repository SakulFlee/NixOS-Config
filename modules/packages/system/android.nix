{ pkgs, ... }: {
  home.packages = with pkgs; [
    # platform tools (adb)
    android-tools
    # MTP
    android-file-transfer
  ];


}