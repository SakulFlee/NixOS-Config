# Only needed to host the SERVER
{ ... }: {
  networking.firewall.allowedTCPPorts = [ 24800 24801 ];
  networking.firewall.allowedUDPPorts = [ 24801 ];
}