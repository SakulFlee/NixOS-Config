{ pkgs, ... }: {
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  programs.coolercontrol.enable = true;
}
