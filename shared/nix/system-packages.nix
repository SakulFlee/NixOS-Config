{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Process monitors
    htop
    btop
    nvtop

    # Display Server
    xauth
  ];
}
