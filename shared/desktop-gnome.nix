{ ... }: {
  # Gnome & GDM
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
}
