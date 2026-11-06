{ pkgs, ... }: {
  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    # Sensors
    lm_sensors

    # CoolerControl for GUI
    coolercontrol.coolercontrol-gui
    coolercontrol.coolercontrold
    coolercontrol.coolercontrol-ui-data
  ];

 # services.fancontrol = {
 #   enable = true;
 #   # Path to your generated fancontrol config (or you can write it inline)
 #   # Most users generate this once using 'sudo pwmconfig' after the driver loads, 
 #   # then paste the resulting config here.
 #   config = ''
 #     INTERVAL=10
 #     DEVPATH=hwmon0=devices/platform/nct6775.656
 #     DEVNAME=hwmon0=nct6687
 #     FCTEMPS=hwmon0/pwm1=hwmon0/temp1_input
 #     FCFANS=hwmon0/pwm1=hwmon0/fan1_input
 #     MINTEMP=hwmon0/pwm1=35
 #     MAXTEMP=hwmon0/pwm1=75
 #     MINSTART=hwmon0/pwm1=150
 #     MINSTOP=hwmon0/pwm1=100
 #     MINPWM=hwmon0/pwm1=0
 #     MAXPWM=hwmon0/pwm1=255
 #   '';
 # };
}
