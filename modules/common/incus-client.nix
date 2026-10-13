{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.incus.client
  ];
}
