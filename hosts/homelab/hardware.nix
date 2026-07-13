{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ../../shared/hardware/firmware.nix
    ../../shared/hardware/microcode.nix
    ../../shared/hardware/i2c.nix
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1be6133a-ae81-40b3-94ae-e30195b638b8";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/1be6133a-ae81-40b3-94ae-e30195b638b8";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/1be6133a-ae81-40b3-94ae-e30195b638b8";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D9DF-0705";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/22ab5fe2-7d6b-4ddf-8296-acec80688802"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}