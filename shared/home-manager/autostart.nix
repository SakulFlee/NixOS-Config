{ pkgs, ... }: {
  # Link autostart entries
  xdg.configFile."autostart/deskflow.desktop".source = "${pkgs.deskflow}/share/applications/org.deskflow.deskflow.desktop";
  xdg.configFile."autostart/sunshine.desktop".source = "${pkgs.sunshine}/share/applications/sunshine.desktop";
  xdg.configFile."autostart/rustdesk.desktop".source = "${pkgs.rustdesk}/share/applications/rustdesk.desktop";
  xdg.configFile."autostart/discord.desktop".source = "${pkgs.discord}/share/applications/discord.desktop";
  xdg.configFile."autostart/obsidian.desktop".source = "${pkgs.obsidian}/share/applications/obsidian.desktop";
  xdg.configFile."autostart/keepassxc.desktop".source = "${pkgs.keepassxc}/share/applications/keepassxc.desktop";

  xdg.configFile."autostart/steam.desktop".text = ''
    [Desktop Entry]
    Name=Steam
    Comment=Application for managing and playing games on Steam
    Exec=${pkgs.steam}/bin/steam -silent
    Icon=steam
    Terminal=false
    Type=Application
    Categories=Network;FileTransfer;Game;
  '';
}

