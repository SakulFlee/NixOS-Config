{ pkgs, ... }: {
  xdg.dataFile."applications/qbittorrent-vpn.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=qBittorrent (VPN)
    Comment=BitTorrent client confined to the PIA VPN namespace
    Exec=/run/current-system/sw/bin/vpn-run ${pkgs.qbittorrent}/bin/qbittorrent %U
    Icon=applications-internet
    Terminal=false
    Categories=Network;FileTransfer;P2P;
    DBusActivatable=false
    StartupNotify=true
  '';

  xdg.dataFile."applications/stremio-vpn.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Stremio (VPN)
    Comment=Stremio confined to the PIA VPN namespace
    Exec=/run/current-system/sw/bin/vpn-run ${pkgs.coreutils}/bin/env WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1 ${pkgs.stremio-linux-shell}/bin/stremio %u
    Icon=${pkgs.stremio-linux-shell}/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg
    Terminal=false
    Categories=AudioVideo;Video;Player;
    MimeType=x-scheme-handler/stremio;
    DBusActivatable=false
    StartupNotify=true
  '';

  # Run ComfyUI in a terminal so it can be stopped with Ctrl+C and its
  # model/GPU logs stay visible. Data lives in ~/.local/share/comfyui.
  xdg.dataFile."applications/comfyui.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=ComfyUI
    Comment=Node-based interface for running diffusion models
    Exec=/run/current-system/sw/bin/kitty /run/current-system/sw/bin/comfyui --auto-launch --preview-method auto --enable-manager
    Icon=applications-graphics
    Terminal=false
    Categories=Graphics;2DGraphics;
    StartupNotify=true
  '';
}
