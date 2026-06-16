{ ... }: {
  users.users.sakulflee = {
    # Required for Sunshine!
    extraGroups = [ "uinput" ];
  };

  hardware.uinput.enable = true;
}
