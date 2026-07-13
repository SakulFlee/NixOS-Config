{ lib, pkgs, ... }: {
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;

      settings = {
        Input = {
          "Keyboard.layout" = "de";
        };
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = 24;
          Font = "Noto Sans,10,-1,0,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
        };
      };
    };

    # mkDefault so hosts (e.g. SteamDeck via Jovian) can override
    defaultSession = lib.mkDefault "plasma";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];

  # KWin compositor (used by SDDM greeter) reads this for keyboard layout
  systemd.services.display-manager.environment.XKB_DEFAULT_LAYOUT = "de";
}
