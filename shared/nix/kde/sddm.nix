{ lib, pkgs, ... }: {
  # SDDM
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
    };

    # mkDefault so hosts (e.g. SteamDeck via Jovian) can override
    defaultSession = lib.mkDefault "plasma";
  };
}
