{ pkgs, ... }: {
  home.packages = with pkgs; [
    htop
    btop
    lmstudio

    # Application Launcher & Tools
    hyprlauncher
    nnn
    thunar

    # System Utilities
    mako
    hyprsunset
    hyprpwcenter
    hyprshutdown

    # General Software
    discord
    floorp
    vlc
  ];
}
