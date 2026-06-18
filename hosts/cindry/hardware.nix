{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    ../../shared/nix-hardware/gpu-nvidia-prime.nix
    ../../shared/nix-hardware/gpu-amdgpu.nix
    ../../shared/nix-hardware/boot-loader.nix
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Disk config
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1f439d9c-9091-443f-bfe5-26268bd52d03";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/1f439d9c-9091-443f-bfe5-26268bd52d03";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/1f439d9c-9091-443f-bfe5-26268bd52d03";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/91F6-9D00";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/417a545e-a9a0-472b-adc1-2428812c1110"; }
    ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # NVIDIA PRIME
  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:5:0:0";
  };

  # WiFi Card (prevents speed and reliability issues)
  boot.extraModprobeConfig = ''
    options mt7921e disable_aspm=1
  '';
  networking.networkmanager.wifi.powersave = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
