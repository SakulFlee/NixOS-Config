git pull origin main
sudo nixos-rebuild switch --flake .#$1
sudo chown -hR sakulflee:root /etc/nixos
