{ pkgs, inputs, ... }:
let
  # ComfyUI in nixpkgs is built against the default (CPU) PyTorch.
  # Re-evaluate nixpkgs with ROCm enabled just for this package, so the
  # rest of the system keeps its normal package set.
  #
  # ROCm 7.2.4 supports gfx1200 (RX 9060 XT), and the ROCm-built
  # torch/torchvision are substitutable from cache.nixos.org.
  pkgsRocm = import inputs.nixpkgs {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      rocmSupport = true;
    };
  };

  comfyui = pkgsRocm.comfyui.override {
    extraPackages = ps: [ ps.comfyui-manager ];
  };
in
{
  environment.systemPackages = [ comfyui ];
}
