-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.del({ "n", "i", "s" }, "<esc>")

vim.keymap.set({ "i" }, "jk", function()
  vim.cmd("noh")
  LazyVim.cmp.actions.snippet_stop()
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

vim.keymap.set({ "n" }, "8", "0")
vim.keymap.set({ "n" }, "9", "^")
vim.keymap.set({ "n" }, "0", "$")

vim.keymap.set({ "i" }, "jj", "<esc>^i")
vim.keymap.set({ "i" }, "kk", "<esc>$a")

--- buffer尺寸调整
vim.keymap.set("n", "<C-Left>", "<C-w>>")
vim.keymap.set("n", "<C-Right>", "<C-w><")
vim.keymap.set("n", "<C-Up>", "<C-w>-")
vim.keymap.set("n", "<C-Down>", "<C-w>+")

--- buffer切换
vim.keymap.set("n", "<S-Left>", "<cmd>bprev<CR>")
vim.keymap.set("n", "<S-Right>", "<cmd>bnext<CR>")

--- 复制选区文件&行范围
vim.keymap.set("x", "<leader>y", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local visual_mode = vim.fn.mode()
  local visual_start = vim.fn.getpos("v")
  local visual_end = vim.fn.getpos(".")
  local file_path = vim.api.nvim_buf_get_name(0)

  local function exit_visual()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  end

  if file_path == "" then
    vim.notify("当前 buffer 没有关联文件", vim.log.levels.WARN)
    exit_visual()
    return
  end

  local start_line = visual_start[2]
  local end_line = visual_end[2]
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local ns = vim.api.nvim_create_namespace("copy_file_location_flash")
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local function add_highlight(line, col_start, col_end)
    vim.api.nvim_buf_add_highlight(bufnr, ns, "IncSearch", line - 1, col_start, col_end)
  end

  if visual_mode == "V" then
    for line = start_line, end_line do
      add_highlight(line, 0, -1)
    end
  elseif visual_mode == "\22" then
    local col_start = math.min(visual_start[3], visual_end[3]) - 1
    local col_end = math.max(visual_start[3], visual_end[3])
    for line = start_line, end_line do
      add_highlight(line, col_start, col_end)
    end
  elseif start_line == end_line then
    add_highlight(
      start_line,
      math.min(visual_start[3], visual_end[3]) - 1,
      math.max(visual_start[3], visual_end[3])
    )
  else
    local first_col = visual_start[3]
    local last_col = visual_end[3]
    if visual_start[2] > visual_end[2] then
      first_col, last_col = last_col, first_col
    end

    add_highlight(start_line, first_col - 1, -1)
    for line = start_line + 1, end_line - 1 do
      add_highlight(line, 0, -1)
    end
    add_highlight(end_line, 0, last_col)
  end

  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    end
  end, 180)

  local location = string.format("`%s#L%d-%d`", vim.fn.fnamemodify(file_path, ":p"), start_line, end_line)
  vim.fn.setreg("+", location)
  -- vim.notify("已复制: " .. location)
  exit_visual()
end, { desc = "Copy file line range" })

--- 调试
vim.keymap.set("n", "<F7>", function()
  require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<F8>", function()
  require("dap").step_into()
end, { desc = "Step Into" })
