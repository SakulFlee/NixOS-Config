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
      conceallevel = 2;
      cmdheight = 0;
      winborder = "rounded";
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };

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
          dashboard.enabled = true;
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
        };
      };

      # ── Navigation & UI ────────────────────────────────────
      aerial = {
        enable   = true;
        settings.backends = [ "lsp" "treesitter" ];
      };
      neo-tree.enable = true;
      which-key.enable = true;

      # ── Smart splits ───────────────────────────────────────
      smart-splits.enable = true;

      # ── Better escape ──────────────────────────────────────
      better-escape.enable = true;

      # ── Auto close/rename tags ─────────────────────────────
      ts-autotag.enable = true;

      # ── Guess indent ───────────────────────────────────────
      guess-indent.enable = true;

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
    };

    # ── LSP ───────────────────────────────────────────────────
    lsp = {
      servers = {
        rust_analyzer.enable = true;
        ts_ls.enable = true;
        html.enable = true;
        cssls.enable = true;
        yamlls.enable = true;
        jsonls.enable = true;
        bashls.enable = true;
        pyright.enable = true;
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

    # ── Heirline (statusline/tabline/winbar) ──────────────────
    extraPlugins = [ pkgs.vimPlugins.heirline-nvim ];

    extraConfigLua = ''
      -- ══════════════════════════════════════════════════════
      -- Heirline Configuration (AstroNvim-style)
      -- ══════════════════════════════════════════════════════
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")

      local colors = {
        section_bg   = utils.get_highlight("StatusLine").bg,
        bright_bg    = utils.get_highlight("Normal").bg,
        red          = utils.get_highlight("DiagnosticError").fg,
        green        = utils.get_highlight("String").fg,
        blue         = utils.get_highlight("Function").fg,
        gray         = utils.get_highlight("NonText").fg,
        orange       = utils.get_highlight("Constant").fg,
        purple       = utils.get_highlight("Statement").fg,
        cyan         = utils.get_highlight("Special").fg,
        darkgray     = utils.get_highlight("CursorLine").bg,
        lightgray    = utils.get_highlight("Visual").bg,
      }

      local Align = { provider = "%=" }
      local Space = { provider = " " }
      local Separator = { provider = " | ", hl = { fg = colors.gray } }

      -- ── Mode indicator ────────────────────────────────────
      local ViMode = {
        init = function(self)
          self.mode = vim.fn.mode(1)
        end,
        static = {
          mode_names = {
            n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE",
            ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE",
            ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE",
            ["!"] = "SHELL", t = "TERMINAL",
          },
          mode_colors = {
            n = colors.blue, i = colors.green, v = colors.purple,
            V = colors.purple, ["\22"] = colors.purple, c = colors.orange,
            s = colors.purple, S = colors.purple, ["\19"] = colors.purple,
            R = colors.red, r = colors.red, ["!"] = colors.cyan,
            t = colors.cyan,
          },
        },
        provider = function(self)
          return " " .. (self.mode_names[self.mode] or self.mode) .. " "
        end,
        hl = function(self)
          return { fg = colors.bright_bg, bg = self.mode_colors[self.mode], bold = true }
        end,
        update = { "ModeChanged", pattern = "*:*" },
      }

      -- ── File name block ───────────────────────────────────
      local FileNameBlock = {
        init = function(self)
          self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
          if self.filename == "" then self.filename = "[No Name]" end
        end,
      }
      local FileName = {
        provider = function(self) return self.filename end,
        hl = { bold = true },
      }
      local FileFlags = {
        { provider = function() return vim.bo.modified and " [+]" or "" end,
          hl = { fg = colors.green } },
        { provider = function() return (not vim.bo.modifiable or vim.bo.readonly) and " [-]" or "" end,
          hl = { fg = colors.red } },
      }
      local FileNameModBlock = utils.insert(FileNameBlock, FileName, FileFlags)

      -- ── Git branch ────────────────────────────────────────
      local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self)
          self.branch = vim.fn.FugitiveHead()
        end,
        provider = function(self) return " " .. self.branch .. " " end,
        hl = { fg = colors.purple, bold = true },
      }

      -- ── Diagnostics ───────────────────────────────────────
      local Diagnostics = {
        condition = conditions.has_diagnostics,
        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,
        {
          provider = function(self) return self.errors > 0 and " " .. self.errors .. " " or "" end,
          hl = { fg = colors.red },
        },
        {
          provider = function(self) return self.warnings > 0 and " " .. self.warnings .. " " or "" end,
          hl = { fg = colors.orange },
        },
        {
          provider = function(self) return self.hints > 0 and " " .. self.hints .. " " or "" end,
          hl = { fg = colors.cyan },
        },
        {
          provider = function(self) return self.info > 0 and " " .. self.info .. " " or "" end,
          hl = { fg = colors.blue },
        },
      }

      -- ── LSP clients ───────────────────────────────────────
      local LspClient = {
        condition = conditions.lsp_attached,
        init = function(self)
          local names = {}
          for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, client.name)
          end
          self.clients = names
        end,
        provider = function(self) return " " .. table.concat(self.clients, " | ") .. " " end,
        hl = { fg = colors.cyan },
      }

      -- ── Filetype ──────────────────────────────────────────
      local FileType = {
        provider = function() return " " .. vim.bo.filetype:upper() .. " " end,
        hl = { fg = colors.gray },
      }

      -- ── Ruler ─────────────────────────────────────────────
      local Ruler = {
        provider = " %l:%c ",
      }

      -- ── Progress ──────────────────────────────────────────
      local Progress = {
        provider = " %P ",
      }

      -- ── StatusLine ────────────────────────────────────────
      local StatusLine = {
        ViMode, Space, FileNameModBlock, Space,
        Diagnostics, Align,
        GitBranch, Separator, LspClient, Separator, FileType, Align,
        Ruler, Progress,
      }

      -- ── WinBar ────────────────────────────────────────────
      local Navic = {
        condition = function() return package.loaded["aerial"] ~= nil end,
        provider = function()
          local status_ok, aerial = pcall(require, "aerial")
          if not status_ok then return "" end
          local symbols = aerial.get_location(true)
          if #symbols == 0 then return "" end
          local parts = {}
          for i, symbol in ipairs(symbols) do
            table.insert(parts, symbol.name)
          end
          return " " .. table.concat(parts, " > ") .. " "
        end,
        hl = { fg = colors.gray },
      }

      local WinBar = {
        condition = function()
          return not conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "neo-tree", "dashboard" },
          })
        end,
        Align, Navic,
      }

      -- ── TabLine ───────────────────────────────────────────
      local TabLineBufnr = {
        provider = function(self) return self.bufnr end,
        hl = { bold = true },
      }
      local TabLineFileName = {
        provider = function(self)
          local name = vim.fn.bufname(self.bufnr)
          name = vim.fn.fnamemodify(name, ":~:.")
          if name == "" then name = "[No Name]" end
          return name:sub(1, 20)
        end,
      }
      local TabLineClose = {
        provider = function(self) return self.is_active and " " or "" end,
        hl = { fg = colors.gray },
      }
      local TabLine = utils.make_tablist(function(self)
        local tabnr = self.tabnr
        local buflist = vim.fn.tabpagebuflist(tabnr)
        local winnr = vim.fn.tabpagewinnr(tabnr)
        self.bufnr = buflist[winnr]
        self.is_active = vim.fn.tabpagenr() == tabnr
        return {
          Space, TabLineBufnr, Space, TabLineFileName, TabLineClose,
          hl = self.is_active
            and { fg = colors.bright_bg, bg = colors.darkgray, bold = true }
            or { fg = colors.gray },
        }
      end)

      require("heirline").setup({
        statusline = StatusLine,
        winbar = WinBar,
        tabline = TabLine,
        opts = {
          disable_winbar_cb = function(args)
            return conditions.buffer_matches({
              buftype = { "nofile", "prompt", "help", "quickfix" },
              filetype = { "^git.*", "fugitive", "neo-tree", "dashboard" },
            }, args.buf)
          end,
        },
      })

      -- ══════════════════════════════════════════════════════
      -- Keymaps
      -- ══════════════════════════════════════════════════════
      local map = vim.keymap.set

      -- ── Window navigation (smart-splits) ──────────────────
      local ss_ok, smart_splits = pcall(require, "smart-splits")
      if ss_ok then
        map("n", "<C-h>", smart_splits.move_cursor_left,  { desc = "Move to left split" })
        map("n", "<C-j>", smart_splits.move_cursor_down,   { desc = "Move to below split" })
        map("n", "<C-k>", smart_splits.move_cursor_up,     { desc = "Move to above split" })
        map("n", "<C-l>", smart_splits.move_cursor_right,  { desc = "Move to right split" })
        map("n", "<C-Left>",  smart_splits.resize_left,    { desc = "Resize split left" })
        map("n", "<C-Down>",  smart_splits.resize_down,    { desc = "Resize split down" })
        map("n", "<C-Up>",    smart_splits.resize_up,      { desc = "Resize split up" })
        map("n", "<C-Right>", smart_splits.resize_right,   { desc = "Resize split right" })
      end

      -- ── Window splits ─────────────────────────────────────
      map("n", "\\", "<cmd>split<cr>", { desc = "Horizontal split" })
      map("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical split" })

      -- ── Buffer navigation ─────────────────────────────────
      map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
      map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
      map("n", ">b", "<cmd>bmove +1<cr>", { desc = "Move buffer right" })
      map("n", "<b", "<cmd>bmove -1<cr>", { desc = "Move buffer left" })
      map("n", "<leader>bc", "<cmd>%bdelete|edit#|bdelete#<cr>", { desc = "Close all other buffers" })
      map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete buffer" })
      map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })

      -- ── Window management ─────────────────────────────────
      map("n", "<C-s>", "<cmd>w<cr>", { desc = "Force write" })
      map("n", "<C-q>", "<cmd>q<cr>", { desc = "Force quit" })

      -- ── LSP keymaps ───────────────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local opts_buf = function(desc)
            return { buffer = ev.buf, desc = desc }
          end

          map("n", "K", vim.lsp.buf.hover, opts_buf("Hover document"))
          map("n", "gd", vim.lsp.buf.definition, opts_buf("Go to definition"))
          map("n", "gD", vim.lsp.buf.declaration, opts_buf("Go to declaration"))
          map("n", "gy", vim.lsp.buf.type_definition, opts_buf("Go to type definition"))
          map("n", "gri", vim.lsp.buf.implementation, opts_buf("Go to implementation"))
          map("n", "grr", vim.lsp.buf.references, opts_buf("References"))
          map("n", "gra", vim.lsp.buf.code_action, opts_buf("Code action"))
          map("n", "grn", vim.lsp.buf.rename, opts_buf("Rename"))
          map("n", "gO", vim.lsp.buf.document_symbol, opts_buf("Document symbols"))

          map("n", "<leader>lf", vim.lsp.buf.format, opts_buf("Format document"))
          map("n", "<leader>la", vim.lsp.buf.code_action, opts_buf("Code action"))
          map("n", "<leader>lr", vim.lsp.buf.rename, opts_buf("Rename"))
          map("n", "<leader>lh", vim.lsp.buf.signature_help, opts_buf("Signature help"))
          map("n", "<leader>ls", vim.lsp.buf.document_symbol, opts_buf("Document symbols"))
          map("n", "<leader>lw", vim.lsp.buf.workspace_symbol, opts_buf("Workspace symbols"))
          map("n", "<leader>lR", vim.lsp.buf.references, opts_buf("References"))
          map("n", "<leader>lS", "<cmd>AerialToggle!<cr>", opts_buf("Symbols outline"))

          map("n", "gl", vim.diagnostic.open_float, opts_buf("Line diagnostics"))
          map("n", "<leader>ld", vim.diagnostic.open_float, opts_buf("Line diagnostics"))
          map("n", "<leader>lD", vim.diagnostic.setloclist, opts_buf("Workspace diagnostics"))
          map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts_buf("Next diagnostic"))
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts_buf("Previous diagnostic"))
          map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, opts_buf("Next error"))
          map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, opts_buf("Previous error"))
          map("n", "]w", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN }) end, opts_buf("Next warning"))
          map("n", "[w", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN }) end, opts_buf("Previous warning"))
        end,
      })

      -- ── DAP keymaps ───────────────────────────────────────
      local dap_ok, dap = pcall(require, "dap")
      if dap_ok then
        map("n", "<leader>dc", dap.continue, { desc = "Continue" })
        map("n", "<leader>dp", dap.pause, { desc = "Pause" })
        map("n", "<leader>dr", dap.restart, { desc = "Restart" })
        map("n", "<leader>ds", dap.run_to_cursor, { desc = "Run to cursor" })
        map("n", "<leader>dq", dap.terminate, { desc = "Terminate" })
        map("n", "<leader>dQ", dap.terminate, { desc = "Terminate" })
        map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        map("n", "<leader>dC", function()
          dap.set_breakpoint(vim.fn.input("Condition: "))
        end, { desc = "Conditional breakpoint" })
        map("n", "<leader>dB", dap.clear_breakpoints, { desc = "Clear breakpoints" })
        map("n", "<leader>do", dap.step_over, { desc = "Step over" })
        map("n", "<leader>di", dap.step_into, { desc = "Step into" })
        map("n", "<leader>dO", dap.step_out, { desc = "Step out" })
        map("n", "<leader>dh", function()
          dap.repl.open({ bufnr = 0 }, "hover")
        end, { desc = "Hover" })
        map("n", "<leader>de", function()
          dap.eval()
        end, { desc = "Evaluate expression" })
        map("n", "<leader>du", function()
          require("dapui").toggle()
        end, { desc = "Toggle DAP UI" })
        map("n", "<F5>", dap.continue, { desc = "Continue" })
        map("n", "<F6>", dap.pause, { desc = "Pause" })
        map("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        map("n", "<F10>", dap.step_over, { desc = "Step over" })
        map("n", "<F11>", dap.step_into, { desc = "Step into" })
        map("n", "<S-F11>", dap.step_out, { desc = "Step out" })
        map("n", "<S-F5>", dap.terminate, { desc = "Terminate" })
        map("n", "<S-F9>", function()
          dap.set_breakpoint(vim.fn.input("Condition: "))
        end, { desc = "Conditional breakpoint" })
      end

      -- ── Terminal keymaps ──────────────────────────────────
      map("n", "<leader>tf", function() Snacks.terminal() end, { desc = "Floating terminal" })
      map("n", "<leader>th", function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } }) end, { desc = "Horizontal terminal" })
      map("n", "<leader>tv", function() Snacks.terminal(nil, { win = { position = "right", width = 0.4 } }) end, { desc = "Vertical terminal" })
      map("n", "<leader>tl", function() Snacks.lazygit() end, { desc = "Lazygit" })
      map({ "n", "t" }, "<F7>", function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })

      -- ── Picker keymaps (snacks.picker) ────────────────────
      map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
      map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Live grep" })
      map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })
      map("n", "<leader>fr", function() Snacks.picker.registers() end, { desc = "Registers" })
      map("n", "<leader>fs", function() Snacks.picker.smart() end, { desc = "Smart find" })
      map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Git files" })
      map("n", "<leader>fc", function() Snacks.picker.grep_word() end, { desc = "Grep word at cursor" })
      map("n", "<leader>fn", function() Snacks.picker.notifications() end, { desc = "Notification history" })
      map("n", "<leader>fC", function() Snacks.picker.commands() end, { desc = "Commands" })
      map("n", "<leader>fm", function() Snacks.picker.man() end, { desc = "Man pages" })
      map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
      map("n", "<leader>ft", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
      map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent files" })

      -- ── Session keymaps (auto-session) ────────────────────
      local gs_ok, gs = pcall(require, "auto-session")
      if gs_ok then
        map("n", "<leader>SS", gs.SaveSession,    { desc = "Save session" })
        map("n", "<leader>SL", gs.RestoreSession, { desc = "Restore session" })
        map("n", "<leader>SD", gs.DeleteSession,  { desc = "Delete session" })
      end

      -- ── Git keymaps ───────────────────────────────────────
      map("n", "<leader>go", function()
        Snacks.picker.git_status()
      end, { desc = "Git status" })
      map("n", "<leader>gc", function()
        Snacks.picker.git_log()
      end, { desc = "Git commits" })
      map("n", "<leader>gb", function()
        Snacks.picker.git_branches()
      end, { desc = "Git branches" })

      -- ── Quickfix / Location list ──────────────────────────
      map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open quickfix list" })
      map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open location list" })
      map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
      map("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix" })

      -- ── AI sidecar terminal split ─────────────────────────
      local function open_in_split(cmd)
        vim.cmd("split | terminal " .. cmd)
        vim.cmd("wincmd p")
      end

      map("n", "<leader>ao", function() open_in_split("opencode") end,
        { desc = "Open OpenCode" })

      -- ── Markdown preview ──────────────────────────────────
      map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>",
        { desc = "Markdown preview" })

      -- ── Treesitter textobjects ────────────────────────────
      local ts_to = function(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject("@" .. query, "textobjects")
        end
      end

      map({ "x", "o" }, "af", ts_to("function.outer"), { desc = "outer function" })
      map({ "x", "o" }, "if", ts_to("function.inner"), { desc = "inner function" })
      map({ "x", "o" }, "ac", ts_to("class.outer"), { desc = "outer class" })
      map({ "x", "o" }, "ic", ts_to("class.inner"), { desc = "inner class" })
      map({ "x", "o" }, "aa", ts_to("parameter.outer"), { desc = "outer parameter" })
      map({ "x", "o" }, "ia", ts_to("parameter.inner"), { desc = "inner parameter" })
      map({ "x", "o" }, "al", ts_to("loop.outer"), { desc = "outer loop" })
      map({ "x", "o" }, "il", ts_to("loop.inner"), { desc = "inner loop" })

      -- ── Dashboard ─────────────────────────────────────────
      map("n", "<leader>h", function() Snacks.dashboard() end, { desc = "Dashboard" })
    '';

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
