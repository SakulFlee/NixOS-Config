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
    hyprshutdown # I will keep this in case they have a custom binary, but we add wlogout for the system
    wlogout
    hyprlock
    hypridle

    # General Software
    discord
    floorp
    vlc
  ];
}
