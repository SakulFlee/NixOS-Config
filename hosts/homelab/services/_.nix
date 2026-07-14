{ lib, ... }: {
  imports = [
    ./postgresql.nix
    ./caddy.nix
    ./website.nix
    ./forgejo.nix
    ./vpn.nix
    ./woodpecker.nix
    ./renovate.nix
    ./minecraft.nix
    ./hytale.nix
    ./jellyfin.nix
    ./prowlarr.nix
    ./sonarr.nix
    ./radarr.nix
    ./qbittorrent.nix
    ./bitmagnet.nix
    ./fansly-recorder.nix
    ./hermes-agent.nix
    ./wireguard.nix
    ./technitium.nix
    ./tuwunel.nix
    ./palworld.nix
    ./syncthing.nix
    ./mautrix-discord.nix
    ./mautrix-whatsapp.nix
  ];
}
