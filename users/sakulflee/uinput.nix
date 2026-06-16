{ ... }: {
  users.users.sakulflee = {
    # Required for Sunshine!
    extraGroups = [ "uinput" ];
  };
}
