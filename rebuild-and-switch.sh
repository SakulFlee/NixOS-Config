#!/usr/bin/env bash

# Clear console
clear

# Pull to check for changes
git pull origin main

# Rebuild
# Note: $1 doesn't have to be set! It defaults to the machine host name.
# It is commonly only needed on first boot before a proper hostname has been set!
sudo nixos-rebuild switch --flake .#$1

