return {
  -- Convert .ipynb files to editable plain-text buffers and back on save
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
  },
  -- Run code in a Jupyter kernel and render output inline
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
    keys = {
      { "<leader>ji", "<cmd>MoltenInit<CR>", desc = "Initialize Jupyter kernel" },
      { "<leader>jl", "<cmd>MoltenEvaluateLine<CR>", desc = "Run current line" },
      { "<leader>jr", "<cmd>MoltenReevaluateCell<CR>", desc = "Re-run cell" },
      { "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<CR>", desc = "Show output" },
      { "<leader>jh", "<cmd>MoltenHideOutput<CR>", desc = "Hide output" },
      { "<leader>jd", "<cmd>MoltenDelete<CR>", desc = "Delete cell" },
      { "<leader>jx", "<cmd>MoltenInterrupt<CR>", desc = "Interrupt kernel" },
      { "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Run selection" },
    },
  },
  -- Optional: For image rendering
  {
    "3rd/image.nvim",
    -- We use the magick_cli processor, so the `magick` Lua rock is not needed.
    -- Without this, lazy.nvim sees the rockspec dependency and keeps trying to
    -- build it (and hererocks), which fails on NixOS.
    build = false,
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli", -- Uses system ImageMagick directly
      })
    end,
  },
}
