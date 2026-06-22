{ ... }: {
  imports = [ ./sddm.nix ];

  environment.etc."xdg/weston/weston.ini".text = ''
    [output]
    name=eDP-1
    transform=180
  '';
}
