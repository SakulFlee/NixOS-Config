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
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli", -- Uses system ImageMagick directly
      })
    end,
  },
}
