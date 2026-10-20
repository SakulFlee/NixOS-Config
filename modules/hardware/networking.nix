{ ... }: {
  networking.networkmanager = {
    enable = true;

    wifi = {
      powersave = true;
    };
  };

  # WireGuard routes the home network (and the container network) through the
  # tunnel at all times, so the HomeLab DNS resolver is always reachable:
  # directly on the LAN at home, through wg0 when away. The FRITZ!Box is kept
  # as a fallback in case the HomeLab is down.
  networking.resolvconf.enable = false;
  environment.etc."resolv.conf".text = ''
    nameserver 192.168.178.200
    nameserver 192.168.178.1
    search fritz.box
  '';
}
