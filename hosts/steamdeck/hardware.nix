{ config, lib, pkgs, modulesPath, ... }: {
  # Additional boot arguments should _mostly_ stay in the host config as they tend to highly customized between hosts
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Disk config
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/da954ab9-0559-4cf4-9004-2826a61078d1";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/da954ab9-0559-4cf4-9004-2826a61078d1";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/da954ab9-0559-4cf4-9004-2826a61078d1";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C78D-6801";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f2aef7fb-e914-4284-8b8d-c920a56d2a4a"; }
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
    enable32Bit = true;
    extraPackages = with pkgs; [ 
      mesa 
      amdgpu_top
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };
  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
