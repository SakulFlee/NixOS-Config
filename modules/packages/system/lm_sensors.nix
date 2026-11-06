{ pkgs, ... }: {
  hardware.sensor.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
}
