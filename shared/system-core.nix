{ pkgs, ... }: {
  # System State
  system.stateVersion = "25.11";

  # Timezone
  time.timeZone = "Europe/Berlin";

  # Language & Locale
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
}
