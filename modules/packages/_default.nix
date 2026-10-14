{ ... }: {
  imports = [
    # Dev
    dev/zed.nix
    dev/lazygit.nix
    dev/neovim.nix
    dev/git.nix
    dev/gpg.nix
    dev/nixfmt.nix

    # AI
    ai/llama-cpp.nix
    ai/opencode.nix
    ai/hermes.nix

    # Creative
    creative/blender.nix
    creative/krita.nix

    # Files
    files/obsidian.nix

    # KDE
    kde/filelight.nix

    # Games
    games/final-fantasy-xiv.nix
    games/protonplus.nix
    games/minecraft.nix
    games/steam.nix
    games/faugus-launcher.nix

    # Internet
    internet/brave.nix
    internet/thunderbird.nix

    # Media
    media/mpv.nix
    media/yt-dlp.nix
    media/ffmpeg.nix
    media/obs-studio.nix
    media/fansly-recorder.nix

    # Office
    office/libreoffice.nix
    office/onlyoffice.nix

    # Security
    security/security.nix

    # Social
    social/signal.nix
    social/discord.nix

    # System
    system/android.nix
    system/zsh.nix
  ];
}
