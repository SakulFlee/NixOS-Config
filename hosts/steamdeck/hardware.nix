{ config, lib, pkgs, modulesPath, ... }: {
  # Disk config
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fad2025e-e33e-45a5-af9a-8338cca5ee97";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2AAA-B9A7";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [{ 
    device = "/dev/disk/by-uuid/dde0c8d0-6d7c-4cb5-ac79-5075540c8fe1"; 
  }];

  # Steam Hardware
  hardware.steam-hardware.enable = true;

  # ZRAM
  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
