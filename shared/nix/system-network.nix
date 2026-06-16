{ ... }: {
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.X11Forwarding = true;
  };
}
