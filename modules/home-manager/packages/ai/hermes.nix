{ inputs, config, ... }: {
  imports = [ inputs.hermes-agent.homeManagerModules.default ];

  sops.secrets."hermes/desktop-token" = {};

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };
  
  services.hermes-agent = {
    enable = true;
    backend.mode = "serve";
    backend.sessionTokenFile = config.sops.secrets."hermes/desktop-token".path;
  };
}
