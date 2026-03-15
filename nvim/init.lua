-- 动动的 Neovim 配置（配合 Cursor VSCode Neovim 插件）

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ========== lazy.nvim 插件管理（vscode 内外都装）==========
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true, -- 明确允许在 vscode 中加载
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      modes = {
        char = { enabled = false },
        search = { enabled = false },
      },
      label = {
        uppercase = false,
        rainbow = { enabled = true, shade = 5 },
      },
    },
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "W", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },
})

if vim.g.vscode then
  local vscode = require("vscode")
  vim.opt.clipboard = "unnamedplus"

  -- ========== 插入模式 ==========
  vim.keymap.set("i", "jj", "<Esc>")

  -- ========== Normal 模式 ==========
  vim.keymap.set("n", "<leader>l", "$")
  vim.keymap.set("n", "<leader>h", "^")

  vim.keymap.set("n", "J", "5j")
  vim.keymap.set("n", "K", "5k")
  vim.keymap.set("n", "L", "5l")
  vim.keymap.set("n", "H", "5h")

  vim.keymap.set("n", "ya", "yaw")
  vim.keymap.set("n", "dj", "daw")

  vim.keymap.set("n", "<leader>q", ":wq<CR>")
  vim.keymap.set("n", "<leader>t", function() vscode.action("cursorTop") end)

  vim.keymap.set("n", "<leader>;", function() vscode.action("editor.action.revealDefinition") end)
  vim.keymap.set("n", "<leader>'", function() vscode.action("workbench.action.navigateBack") end)

  vim.keymap.set("n", "<leader>i", function() vscode.action("workbench.action.nextEditor") end)
  vim.keymap.set("n", "<leader>u", function() vscode.action("workbench.action.previousEditor") end)

  vim.keymap.set("n", "<C-l>", function() vscode.action("workbench.action.nextEditor") end)
  vim.keymap.set("n", "<C-h>", function() vscode.action("workbench.action.previousEditor") end)
  vim.keymap.set("n", "<C-d>", function() vscode.action("workbench.action.closeActiveEditor") end)
  vim.keymap.set("n", "<C-e>", function() vscode.action("workbench.explorer.fileView.focus") end)

  vim.keymap.set("n", "<leader>ww", function() vscode.action("workbench.action.navigateEditorGroups") end)

  vim.keymap.set("n", "CLA", function() vscode.action("workbench.action.closeAllEditors") end)
  vim.keymap.set("n", "CLO", function() vscode.action("workbench.action.closeOtherEditors") end)
  vim.keymap.set("n", "<leader>pcp", function() vscode.action("copyRelativeFilePath") end)

  -- ========== Visual 模式 ==========
  vim.keymap.set("v", "<leader>l", "$h")
  vim.keymap.set("v", "<leader>h", "^")
  vim.keymap.set("v", "J", "5j")
  vim.keymap.set("v", "K", "5k")
  vim.keymap.set("v", "L", "5l")
  vim.keymap.set("v", "H", "5h")
  vim.keymap.set("v", "p", "pgvy")
  vim.keymap.set("v", "<", "<gv")
  vim.keymap.set("v", ">", ">gv")

else
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.clipboard = "unnamedplus"
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.termguicolors = true
end
