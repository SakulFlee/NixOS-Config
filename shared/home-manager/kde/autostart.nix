{ pkgs, ... }: {
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    startup.apps = [
      "${pkgs.discord}/bin/discord"
      "${pkgs.obsidian}/bin/obsidian"
      "${pkgs.steam}/bin/steam"
    ];
  };
}

