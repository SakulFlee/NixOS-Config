{ pkgs, ... }: {
  programs.nixvim = {
    # ── Quality-of-life plugins ────────────────────────────────
    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      comment.enable          = true;
      todo-comments.enable    = true;
      gitsigns.enable         = true;

      # ── Completion: blink.cmp ──────────────────────────────
      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default";
          appearance.nerd_font_variant = "mono";
          completion = {
            documentation.auto_show = true;
            ghost_text.enabled = true;
          };
          sources = {
            default = [ "lazydev" "lsp" "path" "snippets" "buffer" ];
            providers = {
              lazydev = {
                name = "LazyDev";
                module = "lazydev.integrations.blink";
                score_offset = 100;
              };
            };
          };
          fuzzy.implementation = "prefer_rust_with_warning";
          signature.enabled = true;
        };
      };
      blink-compat.enable = true;
      friendly-snippets.enable = true;
      lazydev.enable = true;

      # ── Snacks: expanded QoL suite ─────────────────────────
      snacks = {
        enable = true;
        settings = {
          dashboard = {
            enabled = false;
            sections = [
              { section = "header"; }
              { section = "keys"; gap = 1; padding = 1; }
            ];
            preset = {
              header = ''
                ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
                ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
                ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
                ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
                ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
                ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝'';
              keys = [
                { icon = " "; key = "f"; desc = "Find File"; action = "function() Snacks.picker.files() end"; }
                { icon = " "; key = "r"; desc = "Recent Files"; action = "function() Snacks.picker.recent() end"; }
                { icon = " "; key = "g"; desc = "Git Files"; action = "function() Snacks.picker.git_files() end"; }
                { icon = " "; key = "b"; desc = "Buffers"; action = "function() Snacks.picker.buffers() end"; }
                { icon = " "; key = "s"; desc = "Restore Session"; action = "function() require('auto-session').RestoreSession() end"; }
                { icon = " "; key = "q"; desc = "Quit"; action = "qa"; }
              ];
            };
          };
          notifier = {
            enabled = true;
            timeout = 3000;
          };
          picker = {
            enabled = true;
            sources = {
              files = {};
              grep = {};
              buffers = {};
            };
            win = {
              input.keys = {
                "<C-w>w" = { __unkeyed-1 = "cycle_win"; mode = [ "n" "i" ]; desc = "Cycle windows"; };
                "<C-w>j" = { __unkeyed-1 = "focus_list"; desc = "Focus list"; };
                "<C-w>l" = { __unkeyed-1 = "focus_preview"; desc = "Focus preview"; };
                "<Tab>"  = { __unkeyed-1 = "focus_preview"; mode = [ "n" "i" ]; desc = "Focus preview"; };
              };
              list.keys = {
                "<C-w>w" = { __unkeyed-1 = "cycle_win"; mode = "n"; desc = "Cycle windows"; };
                "<C-w>k" = { __unkeyed-1 = "focus_input"; desc = "Focus input"; };
                "<C-w>l" = { __unkeyed-1 = "focus_preview"; desc = "Focus preview"; };
                "<C-w>h" = { __unkeyed-1 = "focus_input"; desc = "Focus input"; };
                "<Tab>"  = { __unkeyed-1 = "focus_preview"; mode = "n"; desc = "Focus preview"; };
              };
              preview.keys = {
                "<C-w>w" = { __unkeyed-1 = "cycle_win"; mode = "n"; desc = "Cycle windows"; };
                "<C-w>h" = { __unkeyed-1 = "focus_input"; desc = "Focus input"; };
                "<C-w>j" = { __unkeyed-1 = "focus_list"; desc = "Focus list"; };
              };
            };
          };
          indent.enabled = true;
          words.enabled = true;
          scroll.enabled = true;
          quickfile.enabled = true;
          input.enabled = true;
          statuscolumn.enabled = true;
          scope.enabled = true;
          bigfile.enabled = true;
          lazygit.enabled = true;
          explorer.enabled = false;
        };
      };

      # ── Navigation & UI ────────────────────────────────────
      aerial = {
        enable   = true;
        settings.backends = [ "lsp" "treesitter" ];
      };
      neo-tree = {
        enable = true;
        settings = {
          follow_current_file = {
            enabled = true;
            leave_dirs_open = false;
          };
          auto_clean_after_session_restore = true;
          close_if_last_window = true;
          window.width = 25;
        };
      };
      which-key.enable = true;

      # ── Smart splits ───────────────────────────────────────
      smart-splits.enable = true;

      # ── Better escape ──────────────────────────────────────
      better-escape.enable = true;

      # ── Auto close/rename tags ─────────────────────────────
      ts-autotag.enable = true;

      # ── Guess indent ───────────────────────────────────────
      guess-indent = {
        enable = true;
        settings = {
          auto_cmd = true;
          filetype_blacklist = [ "rust" "python" "lua" "nix" "go" ];
        };
      };

      # ── Highlight colors ───────────────────────────────────
      highlight-colors.enable = true;

      # ── Session manager (auto-session) ─────────────────────
      auto-session = {
        enable = true;
        settings = {
          auto_session_enable_last_session = true;
          auto_session_save_enabled         = true;
          auto_session_enabled              = true;
          auto_session_root_dir             = "~/.local/share/nvim/sessions";
        };
      };

      # ── Project manager ────────────────────────────────────
      project-nvim.enable = true;

      # ── Markdown & Obsidian ────────────────────────────────
      render-markdown.enable  = true;
      markdown-preview.enable = true;
      obsidian = {
        enable = true;
        settings = {
          legacy_commands = false;
          workspaces = [
            {
              name = "personal";
              path = "~/Sync/Vault";
            }
          ];
        };
      };

      # ── Formatters (conform.nvim) ──────────────────────────
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua        = [ "stylua" ];
            nix        = [ "nixfmt" ];
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            tsx        = [ "prettier" ];
            html       = [ "prettier" ];
            css        = [ "prettier" ];
            json       = [ "prettier" ];
            yaml       = [ "prettier" ];
            toml       = [ "taplo" ];
            markdown   = [ "prettier" ];
          };
        };
      };

      # ── Treesitter ─────────────────────────────────────────
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable    = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          rust html css javascript typescript tsx
          yaml json toml bash lua nix vim vimdoc
          regex markdown markdown_inline
          python go c cpp java zig sql graphql
        ];
      };
      treesitter-textobjects.enable = true;

      # ── Git: lazygit ───────────────────────────────────────
      lazygit.enable = true;

      # ── Rust: rustaceanvim ─────────────────────────────────
      rustaceanvim.enable = true;
    };
  };
}
