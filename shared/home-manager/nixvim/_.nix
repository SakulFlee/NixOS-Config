{ inputs, pkgs, ... }: {
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    opts = {
      relativenumber = true;
      number = true;
      signcolumn = "yes";
      wrap = false;
      termguicolors = true;
      updatetime = 250;
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

    extraConfigLua = ''
      -- ── AI sidecar terminal split ────────────────────────────
      local function open_in_split(cmd)
        vim.cmd("split | terminal " .. cmd)
        vim.cmd("wincmd p")
      end

      vim.keymap.set("n", "<leader>ao", function() open_in_split("opencode") end,
        { desc = "Open OpenCode" })

      -- ── Session keymaps (auto-session) ──────────────────────
      local gs_ok, gs = pcall(require, "auto-session")
      if gs_ok then
        vim.keymap.set("n", "<leader>qs", gs.SaveSession,    { desc = "Save session" })
        vim.keymap.set("n", "<leader>ql", gs.RestoreSession, { desc = "Restore session" })
        vim.keymap.set("n", "<leader>qd", gs.DeleteSession,  { desc = "Delete session" })
      end

      -- ── Markdown preview ───────────────────────────────────
      vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>",
        { desc = "Markdown preview" })
    '';

    # ── Quality-of-life plugins ────────────────────────────────
    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      comment.enable          = true;
      indent-blankline.enable = true;
      todo-comments.enable    = true;
      gitsigns.enable         = true;
      lualine.enable          = true;
      aerial = {
        enable   = true;
        settings.backends = [ "lsp" "treesitter" ];
      };
      neo-tree = {
        enable       = true;
      };
      telescope.enable = true;
      which-key = {
        enable = true;
      };

      # ── Session manager (auto-session) ───────────────────────
      auto-session = {
        enable = true;
        settings = {
          auto_session_enable_last_session = true;
          auto_session_save_enabled         = true;
          auto_session_enabled              = true;
          auto_session_root_dir             = "~/.local/share/nvim/sessions";
        };
      };

      # ── Project manager ─────────────────────────────────────
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

      # ── Formatters (conform.nvim) ─────────────────────────
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

      # ── Dashboard (snacks) ───────────────────────────────
      snacks = {
        enable = true;
        settings.dashboard = { enabled = true; };
      };

      # ── Treesitter (parsers from nixpkgs) ────────────────
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
        ];
      };

      # ── Git: lazygit ─────────────────────────────────────
      lazygit.enable = true;
    };

    # ── LSP ───────────────────────────────────────────────────
    lsp = {
      keymaps = [
        {
          key = "<leader>rn";
          lspBufAction = "rename";
        }
        {
          key = "<leader>ca";
          lspBufAction = "code_action";
        }
        {
          key = "<leader>fs";
          action = "<CMD>LspDocumentSymbol<Enter>";
        }
      ];

      servers = {
        rust_analyzer.enable = true;
        ts_ls.enable = true;
        html.enable = true;
        cssls.enable = true;
        yamlls.enable = true;
        jsonls.enable = true;
        bashls.enable = true;
      };
    };

    # ── DAP (debugger) ───────────────────────────────────────
    plugins.dap = {
      enable = true;
      adapters = {
        executables.codelldb = {
          command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter}/bin/codelldb";
          args    = [ "--port" "13000" ];
        };
      };
      configurations = {
        rust = [
          {
            type          = "codelldb";
            request       = "launch";
            name          = "Launch";
            cwd           = ''''${workspaceFolder}'';
            program.__raw = ''
              function()
                return vim.fn.input(
                  "Path: ",
                  vim.fn.getcwd() .. "/",
                  "file"
                )
              end
            '';
            args.__raw = ''
              function()
                local args = {}
                for _, arg in ipairs(vim.fn.input("Args: "):gmatch("%S+")) do
                  table.insert(args, arg)
                end
                return args
              end
            '';
            runInTerminal = true;
          }
        ];
      };
    };
    plugins.dap-ui.enable           = true;
    plugins.dap-virtual-text.enable = true;

  };

  # CLI tools that plugins shell out to
  home.packages = with pkgs; [
    lazygit
    ripgrep
    fd
    tree-sitter
    vscode-extensions.vadimcn.vscode-lldb.adapter
  ];
}
