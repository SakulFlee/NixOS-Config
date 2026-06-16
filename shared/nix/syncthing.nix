{ ... }: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "sakulflee";
    dataDir = "/home/sakulflee";
  };
}
