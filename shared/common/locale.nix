{ pkgs, ... }: {
  # Timezone
  time.timeZone = "Europe/Berlin";

  # Language & Locale
  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
  console.keyMap = "de";
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
}
