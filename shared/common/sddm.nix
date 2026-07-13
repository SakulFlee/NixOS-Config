{ lib, pkgs, ... }: {
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;

      settings = {
        Input = {
          "Keyboard.layout" = "de";
        };
      };
    };

    # mkDefault so hosts (e.g. SteamDeck via Jovian) can override
    defaultSession = lib.mkDefault "plasma";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];
}
