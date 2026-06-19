{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    ../../shared/nix-hardware/gpu-nvidia-prime.nix
    ../../shared/nix-hardware/gpu-amdgpu.nix
    ../../shared/nix-hardware/redistributable-hardware.nix
    ../../shared/nix-hardware/microcode.nix
    ../../shared/nix-hardware/wifi-mt7921e.nix
  ];

  # Needs to be set by every platform host
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Additional boot arguments should _mostly_ stay in the host config as they tend to highly customized between hosts
  # TODO

  # Disk config
  # TODO 

  # NVIDIA PRIME
  # TODO 
}
