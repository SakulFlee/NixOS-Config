{ users }: { inputs, ... }: {
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;

    container = {
      enable = true;
      hostUsers = users;
    };

    # settings.model.default = "anthropic/claude-sonnet-4";
    # environmentFiles = [ config.sops.secrets."hermes-env".path ];

  };
}
