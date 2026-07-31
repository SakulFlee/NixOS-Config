{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };

  systemd.services.ollama.serviceConfig = {
    SupplementaryGroups = [ "render" "video" ];
  };
}
