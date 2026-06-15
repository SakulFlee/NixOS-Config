#!/usr/bin/env bash

sudo nix-shell -I nixpkgs=channel:nixos-unstable -p sops age ssh-to-age --run bash << 'EOF'
  SOPS_AGE_KEY=$(ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key) sops secrets.yaml
EOF

