-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- vim.keymap.del({ "n", "i", "s" }, "<esc>")

--- xx -> esc
--- vim.keymap.set({ "i", "n", "s", "v" }, "xx", function()
---   vim.cmd("noh")
---   LazyVim.cmp.actions.snippet_stop()
---   return "<esc>"
--- end, { expr = true, desc = "Escape and Clear hlsearch" })

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

--- 调试
vim.keymap.set("n", "<F7>", function()
  require("dap").step_over()
end, { desc = "Step Over" })
vim.keymap.set("n", "<F8>", function()
  require("dap").step_into()
end, { desc = "Step Into" })
