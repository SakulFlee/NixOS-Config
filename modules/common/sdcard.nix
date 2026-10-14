{ ... }: {
  # Allows your file manager to mount local drives/SD cards without root permissions
  services.udisks2.enable = true;
}
