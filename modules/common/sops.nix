{ config, pkgs, inputs, ... }: {
  # Enable sops-nix module
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  # Tell SOPS where your encrypted file lives in your repo
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # Sets the GPG key location for SOPS
  sops.gnupg = {
    home = "/home/sakulflee/.gnupg";
  };

  environment.systemPackages = with pkgs; [
    sops
    age
    ssh-to-age
  ];
}
