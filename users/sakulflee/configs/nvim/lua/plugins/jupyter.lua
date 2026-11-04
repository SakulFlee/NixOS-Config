return {
  -- Plugin to convert .ipynb to editable python scripts
  {
    "GCBallesteros/jupytext.nvim",
  },
  -- Plugin to run code and display output inline
  {
    "benlubas/molten-nvim",
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
