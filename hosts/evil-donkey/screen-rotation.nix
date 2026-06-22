{ ... }: {
  environment.etc."xdg/weston/weston.ini".text = ''
    [output]
    name=eDP-1
    transform=180
  '';

  systemd.user.services.rotate-kde = {
    description = "Rotate KDE Plasma display by 180 degrees";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    
    script = ''
      # Replace 'eDP-1' with your actual display output name
      ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.eDP-1.rotation.inverted
    '';
  };
}
