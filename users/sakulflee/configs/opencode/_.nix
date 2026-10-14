{ pkgs, ... }: {
    home.packages = with pkgs; [
      opencode
      opencode-desktop
    ];

    home.file.".config/opencode/opencode.jsonc".source = ./opencode.jsonc;
}
