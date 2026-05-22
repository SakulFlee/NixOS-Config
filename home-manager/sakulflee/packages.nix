{ pkgs, ... }: {
  home.packages = with pkgs; [
    htop
    btop
    lmstudio

    # Application Launcher & Tools
    hyprlauncher
    nnn
    xfce.thunar
    fzf

    # System Utilities
    mako
    hyprsunset
    hyprpwcenter
    hyprshutdown
    wlogout
    wlsunset
    hyprlock
    hypridle

    # General Software
    discord
    floorp
    vlc
  ];
}
