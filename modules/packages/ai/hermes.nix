{ users }: { inputs, ... }: {
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  services.hermes-agent = {
    enable = true;
    gateway.enable = true;
    backend.mode = "dashboard"; # + the browser dashboard on 127.0.0.1:9119
    backend.port = 9119;

    addToSystemPackages = true;

    container = {
      enable = true;
      hostUsers = users;
    };
  };
}
