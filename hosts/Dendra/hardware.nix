{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    ../../modules/hardware/_.nix
    ../../modules/hardware/gpu-amdgpu.nix
    ../../modules/hardware/wifi-mt7921e.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/200030cb-36bd-478c-81a6-250720433196";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/200030cb-36bd-478c-81a6-250720433196";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/200030cb-36bd-478c-81a6-250720433196";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/757C-C68F";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/nvme" = {
    device = "/dev/disk/by-uuid/b3c527bd-9930-4bef-a013-42edbaa01de8";
    fsType = "btrfs";
  };

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/02c8c213-7a5b-4bf1-97da-749dd87b3417";
    fsType = "btrfs";
  };


  swapDevices = [ { device = "/dev/disk/by-uuid/d151c4c7-d8d3-481a-8c73-25ae8dd6264e"; } ];
  boot.resumeDevice = "/dev/disk/by-uuid/d151c4c7-d8d3-481a-8c73-25ae8dd6264e";
}
