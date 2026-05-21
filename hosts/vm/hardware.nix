{ config, lib, pkgs, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/861f305b-5dd5-4500-b602-2e286dca334d";
      fsType = "ext4";
    };

  swapDevices = [{ 
    device = "/var/lib/swapfile"; 
    size = 4 * 1024;
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
