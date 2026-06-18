{ config, ... }: {
  imports = [
    ./gpu-mesa.nix
  ];

  services.xserver.videoDrivers = [
    "amdgpu"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.mesa ];
  };

  hardware.nvidia = {
    # Modesetting
    modesetting.enable = true;

    # Experimental!
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;

    # Include nvidia settings app
    nvidiaSettings = true;
  };
}
