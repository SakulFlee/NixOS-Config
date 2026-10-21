{ config, ... }:
{
  programs.plasma.configFile."plasmavaultrc" = {
    EncryptedDevices."/mnt/ssd/NSFW" = true;

    # plasma-manager treats "/" as a nested-group separator, so literal
    # slashes in the vault's device path must be escaped.
    "\\/mnt\\/ssd\\/NSFW" = {
      name = "NSFW";
      backend = "gocryptfs";
      mountPoint = "${config.home.homeDirectory}/NSFW";
      offlineOnly = false;
    };
  };
}
