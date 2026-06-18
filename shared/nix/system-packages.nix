{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Process monitors
    htop
    btop
    nvtopPackages.full
    
    # Display Server
    xauth

    # System packages
    git
    curl
    wget
    zip
    unzip
    gnutar
    busybox
    diffutils

    # RGB control
    openrgb-with-all-plugins

    # KDE Plasma
    kdePackages.plasma-systemmonitor
  ];
}
