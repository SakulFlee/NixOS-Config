return {
  -- Plugin to convert .ipynb to editable python scripts
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
    -- Disable lazy loading to ensure jupytext is available immediately
    lazy = false,
  },
  -- Plugin to run code and display output inline
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- Use latest stable
    build = ":MoltenInstall",
    config = function()
      -- Optional: Configure molten here
    end,
  },
  -- Optional: For image rendering
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup({
        backend = "kitty",
      })
    end,
  },
}
