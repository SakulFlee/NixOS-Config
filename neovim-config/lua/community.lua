-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.ai.opencode-nvim" },
  -- Tools
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.undotree" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.project.projectmgr-nvim" },
  -- Themes
  { import = "astrocommunity.colorscheme.catppuccin" },
}
