{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Process monitors
    htop
    btop
    nvtop
    
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
    diff
  ];
}
