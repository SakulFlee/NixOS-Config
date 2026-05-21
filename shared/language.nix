{ ... }: {
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "de";

  # Only needed in x11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  }
}
