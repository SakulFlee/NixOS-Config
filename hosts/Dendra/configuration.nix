{ lib, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./syncthing.nix
    ../../users/_.nix
    ../../modules/common/_.nix
#    ../../modules/common/optionals/openrgb.nix
#    ../../modules/common/optionals/vbox.nix
    ../../modules/games/_.nix

    (import ../../modules/services/wireguard.nix {
      address = [ "100.64.0.2/32" ];
      allowedIPs = [ "192.168.178.0/24" "100.64.0.0/10" ];
    })

    (import ../../modules/services/hermes-agent.nix {
      users = [ "sakulflee" ];
    })

    ../../modules/services/openvpn.nix
    ../../modules/packages/dev/neovim.nix
  ];
  # Hostname
  networking.hostName = "Dendra";
}
