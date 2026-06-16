{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Process monitors
    htop
    btop
    nvtop

    # Display Server
    xauth

    # SOPS
    sops
    age
    ssh-to-age
  ];
}
