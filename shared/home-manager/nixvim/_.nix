{ inputs, pkgs, unstable, ... }: {
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorscheme = "catppuccin-mocha";

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

    # ── Dashboard (snacks) ─────────────────────────────────────
    startscreen = "dashboard";

    snacks = {
      enable = true;
      dashboard.enable = true;
    };

    # ── Quality-of-life plugins ────────────────────────────────
    plugins = {
      autopairs.enable        = true;
      surround.enable         = true;
      comment.enable          = true;
      indent-blankline.enable = true;
      todo-comments.enable    = true;
      gitsigns.enable         = true;
      lualine.enable          = true;
      aerial = {
        enable   = true;
        backends = { lsp = true; treesitter = true; };
      };
      neo-tree = {
        enable       = true;
        openOnStart  = false;
      };
      telescope.enable = true;
      which-key = {
        enable = true;
        settings.preset.lazy = false;
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
      projectmgr-nvim.enable = true;

      # ── Markdown & Obsidian ────────────────────────────────
      render-markdown.enable  = true;
      markdown-preview.enable = true;
      obsidian = {
        enable = true;
        settings = {
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
    };

    # ── Treesitter (parsers from nixpkgs) ─────────────────────
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable    = true;
      };
      grammars = [
        "rust" "html" "css" "javascript" "typescript" "tsx"
        "yaml" "json" "toml" "bash" "lua" "nix" "vim" "vimdoc"
        "regex" "markdown" "markdown_inline"
      ];
    };

    # ── LSP ───────────────────────────────────────────────────
    lsp = {
      enable = true;
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
        codelldb = {
          type    = "executable";
          command = "${pkgs.codelldb}/bin/codelldb";
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

    # ── Git: lazygit ─────────────────────────────────────────
    git.lazygit.enable = true;

    # ── OpenCode.nvim (sudo-tee/opencode.nvim) ───────────────
    extraPlugins = [
      (pkgs.vimPlugins.buildVimPlugin {
        pname    = "opencode-nvim";
        version  = "unstable";
        src = pkgs.fetchFromGitHub {
          owner   = "sudo-tee";
          repo    = "opencode.nvim";
          rev     = "main";
          sha256  = "0000000000000000000000000000000000000000000000000000";
        };
      })
    ];
  };

  # CLI tools that plugins shell out to
  home.packages = with pkgs; [
    lazygit
    ripgrep
    fd
    tree-sitter
    codelldb
  ] ++ [ unstable.opencode ];
}
