-- Helpers for running Jupytext `# %%` cells through Molten.
local function get_lines()
  return vim.api.nvim_buf_get_lines(0, 0, -1, false)
end

local function is_cell_marker(line)
  return line:match("^# %%%%") ~= nil
end

local function trim_range(first, last)
  local lines = get_lines()
  while first <= last and lines[first]:match("^%s*$") do
    first = first + 1
  end
  while last >= first and lines[last]:match("^%s*$") do
    last = last - 1
  end
  if first > last then
    return nil
  end
  return first, last
end

local function current_cell()
  local lines = get_lines()
  local cursor = vim.api.nvim_win_get_cursor(0)[1]

  local start_marker = 0
  for i = cursor, 1, -1 do
    if is_cell_marker(lines[i]) then
      start_marker = i
      break
    end
  end

  local end_marker = #lines + 1
  for i = cursor + 1, #lines do
    if is_cell_marker(lines[i]) then
      end_marker = i
      break
    end
  end

  local first, last = trim_range(start_marker + 1, end_marker - 1)
  if not first then
    return nil
  end

  local marker = start_marker > 0 and lines[start_marker] or ""
  return {
    first = first,
    last = last,
    start_marker = start_marker,
    is_markdown = marker:match("%[markdown%]") ~= nil,
  }
end

local function eval_range(first, last)
  local lines = get_lines()
  first, last = trim_range(first, last)
  if not first then
    return
  end

  -- MoltenEvaluateRange is broken/unavailable in some Molten versions, so use
  -- the visual command with programmatically-set marks instead.
  vim.fn.setpos("'<", { 0, first, 1, 0 })
  vim.fn.setpos("'>", { 0, last, #lines[last], 0 })
  vim.cmd("MoltenEvaluateVisual")
end

local function notify(msg)
  vim.notify(msg, vim.log.levels.WARN)
end

local function has_kernel()
  local ok, kernels = pcall(vim.fn.MoltenStatusLineKernels, true)
  return ok and kernels ~= nil and kernels ~= vim.NIL and kernels ~= ""
end

local function run_cell()
  local cell = current_cell()
  if not cell then
    return notify("Not in a notebook cell")
  end
  if cell.is_markdown then
    return notify("Current cell is a markdown cell")
  end
  eval_range(cell.first, cell.last)
end

local function all_cells()
  local lines = get_lines()
  local markers = {}
  for i, line in ipairs(lines) do
    if is_cell_marker(line) then
      table.insert(markers, i)
    end
  end

  if #markers == 0 then
    local first, last = trim_range(1, #lines)
    return first and { { first = first, last = last, is_markdown = false } } or {}
  end

  local cells = {}
  -- Include real code before the first marker, but skip the Jupytext YAML header.
  if markers[1] > 1 then
    local has_code = false
    for i = 1, markers[1] - 1 do
      local line = lines[i]
      if line:match("%S") and not line:match("^%s*#") then
        has_code = true
        break
      end
    end
    if has_code then
      local first, last = trim_range(1, markers[1] - 1)
      if first then
        table.insert(cells, { first = first, last = last, is_markdown = false })
      end
    end
  end

  for i, marker in ipairs(markers) do
    local next_marker = markers[i + 1] or (#lines + 1)
    local first, last = trim_range(marker + 1, next_marker - 1)
    if first then
      table.insert(cells, {
        first = first,
        last = last,
        is_markdown = lines[marker]:match("%[markdown%]") ~= nil,
      })
    end
  end
  return cells
end

local function code_cells(cells)
  return vim.tbl_filter(function(cell)
    return not cell.is_markdown
  end, cells)
end

local function eval_cells(cells)
  cells = code_cells(cells)
  if #cells == 0 then
    return vim.notify("No code cells to run", vim.log.levels.INFO)
  end

  local run = function()
    for _, cell in ipairs(cells) do
      eval_range(cell.first, cell.last)
    end
  end

  -- If no kernel is attached yet, initialize one and wait until it is actually
  -- ready. MoltenInitPost fires before the kernel can receive code, so using it
  -- can silently drop the first batch of cells.
  if not has_kernel() then
    local group = vim.api.nvim_create_augroup("MoltenRunCells", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "MoltenKernelReady",
      once = true,
      group = group,
      callback = function()
        vim.schedule(run)
      end,
    })
    vim.cmd("MoltenInit")
  else
    run()
  end
end

local function run_all()
  eval_cells(all_cells())
end

local function run_above()
  local cell = current_cell()
  if not cell then
    return notify("Not in a notebook cell")
  end
  local cells = vim.tbl_filter(function(c)
    return c.last < cell.first
  end, all_cells())
  if #cells == 0 then
    return vim.notify("No cells above", vim.log.levels.INFO)
  end
  eval_cells(cells)
end

local function run_below()
  local cell = current_cell()
  if not cell then
    return notify("Not in a notebook cell")
  end
  local cells = vim.tbl_filter(function(c)
    return c.first >= cell.first
  end, all_cells())
  if #cells == 0 then
    return vim.notify("No cells below", vim.log.levels.INFO)
  end
  eval_cells(cells)
end

local function run_after()
  local cell = current_cell()
  if not cell then
    return notify("Not in a notebook cell")
  end
  local cells = vim.tbl_filter(function(c)
    return c.first > cell.last
  end, all_cells())
  if #cells == 0 then
    return vim.notify("No cells below", vim.log.levels.INFO)
  end
  eval_cells(cells)
end

local function run_to()
  local cell = current_cell()
  if not cell then
    return notify("Not in a notebook cell")
  end
  local cells = vim.tbl_filter(function(c)
    return c.last <= cell.last
  end, all_cells())
  if #cells == 0 then
    return vim.notify("No cells to run", vim.log.levels.INFO)
  end
  eval_cells(cells)
end

local function define_commands()
  vim.api.nvim_create_user_command("MoltenRunCell", run_cell, { desc = "Run current notebook cell" })
  vim.api.nvim_create_user_command("MoltenRunAll", run_all, { desc = "Run all notebook cells" })
  vim.api.nvim_create_user_command("MoltenRunAbove", run_above, { desc = "Run all cells above" })
  vim.api.nvim_create_user_command("MoltenRunBelow", run_below, { desc = "Run current cell and all below" })
  vim.api.nvim_create_user_command("MoltenRunAfter", run_after, { desc = "Run all cells below current" })
  vim.api.nvim_create_user_command("MoltenRunTo", run_to, { desc = "Run all cells through current" })
end

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
      -- Keep outputs visible below the cell instead of relying on the float.
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      define_commands()
    end,
    keys = {
      { "<leader>ji", "<cmd>MoltenInit<CR>", desc = "Initialize Jupyter kernel" },
      { "<leader>jc", run_cell, desc = "Run current cell" },
      { "<leader>jr", "<cmd>MoltenReevaluateCell<CR>", desc = "Re-run current cell" },
      { "<leader>ja", run_all, desc = "Run all cells" },
      { "<leader>jb", run_above, desc = "Run cells above" },
      { "<leader>jf", run_after, desc = "Run cells below (excluding current)" },
      { "<leader>jn", run_below, desc = "Run current cell and below" },
      { "<leader>jt", run_to, desc = "Run cells through current" },
      { "<leader>jl", "<cmd>MoltenEvaluateLine<CR>", desc = "Run current line" },
      { "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Run selection" },
      { "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<CR>", desc = "Show/enter output" },
      { "<leader>jy", "<cmd>MoltenYankOutput<CR>", desc = "Yank cell output" },
      { "<leader>jh", "<cmd>MoltenHideOutput<CR>", desc = "Hide output" },
      { "<leader>jd", "<cmd>MoltenDelete<CR>", desc = "Delete cell" },
      { "<leader>jx", "<cmd>MoltenInterrupt<CR>", desc = "Interrupt kernel" },
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
