{ config, lib, pkgs, modulesPath, ... }: {
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/861f305b-5dd5-4500-b602-2e286dca334d";
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

  # ZRAM
  zramSwap.enable = true;

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
