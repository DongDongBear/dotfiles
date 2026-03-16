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
  -- Flash.nvim — EasyMotion 替代
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

  -- nvim-surround — 快速操作括号/引号
  {
    "kylechui/nvim-surround",
    vscode = true,
    event = "VeryLazy",
    opts = {},
  },

  -- vim-repeat — . 重复增强
  {
    "tpope/vim-repeat",
    vscode = true,
    event = "VeryLazy",
  },

  -- treesitter 本体
  {
    "nvim-treesitter/nvim-treesitter",
    vscode = true,
    build = ":TSUpdate",
    event = "VeryLazy",
  },

  -- treesitter-textobjects — 语法级文本对象
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    vscode = true,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
        },
      })

      local select = function(query)
        return function()
          require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
        end
      end

      local move = require("nvim-treesitter-textobjects.move")

      -- 文本对象：函数
      vim.keymap.set({ "x", "o" }, "af", select("@function.outer"))
      vim.keymap.set({ "x", "o" }, "if", select("@function.inner"))
      -- 文本对象：类
      vim.keymap.set({ "x", "o" }, "ac", select("@class.outer"))
      vim.keymap.set({ "x", "o" }, "ic", select("@class.inner"))
      -- 文本对象：参数
      vim.keymap.set({ "x", "o" }, "aa", select("@parameter.outer"))
      vim.keymap.set({ "x", "o" }, "ia", select("@parameter.inner"))

      -- 跳转：下一个/上一个函数
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
      -- 跳转：下一个/上一个参数
      vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.outer", "textobjects") end)
    end,
  },
})

-- ========== VSCode/Cursor 专属配置 ==========
if vim.g.vscode then
  local vscode = require("vscode")
  vim.opt.clipboard = "unnamedplus"

  -- 注释
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

  -- Claude Code
  vim.keymap.set("n", "<leader>cc", function()
    local cwd = vim.fn.getcwd()
    vim.fn.jobstart(
      string.format("/Applications/Ghostty.app/Contents/MacOS/ghostty -e claude --working-directory %s &", vim.fn.shellescape(cwd)),
      { detach = true, shell = true }
    )
  end)

  -- 折叠（修复 za 意外切换 tab）
  vim.keymap.set("n", "za", function() vscode.action("editor.toggleFold") end)
  vim.keymap.set("n", "zc", function() vscode.action("editor.fold") end)
  vim.keymap.set("n", "zo", function() vscode.action("editor.unfold") end)
  vim.keymap.set("n", "zM", function() vscode.action("editor.foldAll") end)
  vim.keymap.set("n", "zR", function() vscode.action("editor.unfoldAll") end)

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
