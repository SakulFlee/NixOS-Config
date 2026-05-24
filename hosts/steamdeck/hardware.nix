{ config, lib, pkgs, modulesPath, ... }: {
  # Disk config
    fileSystems."/" =
    { device = "/dev/disk/by-uuid/be9cbef6-0a9f-4a94-8627-766ea4cff995";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F28F-32D3";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/bf363541-aef5-42b5-ac4b-316a76b262e0"; }
    ];

  # Steam Hardware
  hardware.steam-hardware.enable = true;

  # ZRAM
  zramSwap.enable = true;

  # Microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # GPU
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
