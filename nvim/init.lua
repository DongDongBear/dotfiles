-- 动动的 Neovim 配置（配合 Cursor VSCode Neovim 插件）

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ========== lazy.nvim 插件管理 ==========
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Flash.nvim — EasyMotion 替代，按 f 跳转
  {
    "folke/flash.nvim",
    vscode = true,
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      modes = { char = { enabled = false }, search = { enabled = false } },
      label = { uppercase = false, rainbow = { enabled = true, shade = 5 } },
    },
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "W", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  -- nvim-surround — 快速操作括号/引号 (ys/cs/ds)
  {
    "kylechui/nvim-surround",
    vscode = true,
    event = "VeryLazy",
    opts = {},
  },

  -- vim-repeat — 让 surround 等插件支持 . 重复
  {
    "tpope/vim-repeat",
    vscode = true,
    event = "VeryLazy",
  },

  -- nvim-treesitter-textobjects — 语法级文本对象 (vaf/vaa/vic)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    vscode = true,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

  -- treesitter 本体（textobjects 依赖）
  {
    "nvim-treesitter/nvim-treesitter",
    vscode = true,
    build = ":TSUpdate",
    event = "VeryLazy",
    opts = {
      ensure_installed = { "javascript", "typescript", "tsx", "json", "html", "css", "lua" },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",   -- 选整个函数
            ["if"] = "@function.inner",   -- 选函数体
            ["ac"] = "@class.outer",      -- 选整个 class
            ["ic"] = "@class.inner",      -- 选 class 体
            ["aa"] = "@parameter.outer",  -- 选参数（含逗号）
            ["ia"] = "@parameter.inner",  -- 选参数值
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",   -- 跳到下一个函数
            ["]a"] = "@parameter.outer",  -- 跳到下一个参数
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",   -- 跳到上一个函数
            ["[a"] = "@parameter.outer",  -- 跳到上一个参数
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
})

-- ========== VSCode/Cursor 专属配置 ==========
if vim.g.vscode then
  local vscode = require("vscode")
  vim.opt.clipboard = "unnamedplus"

  -- 注释（VSCode Neovim 内置支持）
  vim.keymap.set("n", "gc", "<Plug>VSCodeCommentary")
  vim.keymap.set("x", "gc", "<Plug>VSCodeCommentary")
  vim.keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine")

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
  -- ========== 终端 Neovim ==========
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.clipboard = "unnamedplus"
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.termguicolors = true
end
