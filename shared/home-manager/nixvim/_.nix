{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./plugins.nix
    ./lsp.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.source = pkgs.path;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    opts = {
      relativenumber = true;
      number = true;
      signcolumn = "yes";
      wrap = true;
      spell = true;
      spelllang = "en_us";
      termguicolors = true;
      updatetime = 250;
      conceallevel = 2;
      cmdheight = 0;
      winborder = "rounded";
      expandtab = true;
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    # ── Extra plugins (not in nixvim module) ──────────────────
    extraPlugins = [
      pkgs.vimPlugins.heirline-nvim
      pkgs.vimPlugins.nvim-lsp-file-operations
      (pkgs.vimUtils.buildVimPlugin {
        name = "sudo-tee-opencode-nvim";
        src = inputs.sudo-tee-opencode-nvim;
      })
    ];

    # ── Lua configuration ─────────────────────────────────────
    extraConfigLuaPre = builtins.readFile ./keymaps.lua;
    extraConfigLua    = builtins.readFile ./heirline.lua + ''
      require("snacks.notifier")

      require("opencode").setup({
        keymap_prefix = "<leader>ao",
      })
    '';

    extraConfigLuaPost = builtins.readFile ./autocmds.lua;
  };

  # CLI tools that plugins shell out to
  home.packages = with pkgs; [
    lazygit
    ripgrep
    fd
    tree-sitter
    opencode
    vscode-extensions.vadimcn.vscode-lldb.adapter
  ];
}
