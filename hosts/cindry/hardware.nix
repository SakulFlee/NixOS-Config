{ config, lib, pkgs, modulesPath, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  # ZRAM
  zramSwap.enable = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # GPU config
  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa ];
  };
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  hardware.nvidia = {
    # Modesetting
    modesetting.enable = true;

    # Experimental!
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;

    # Include settings app?
    nvidiaSettings = true;

    # Prime
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:5:0:0";
    };
  };

  # WiFi Card (prevents speed and reliability issues)
  boot.extraModprobeConfig = ''
    options mt7921e disable_aspm=1
  '';
  networking.networkmanager.wifi.powersave = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
