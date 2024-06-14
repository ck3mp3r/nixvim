vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.clipboard = "unnamedplus"
vim.opt.colorcolumn = "120"
vim.opt.conceallevel = 1
vim.opt.cursorcolumn = false
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.undofile = true

local lazy_path = vim.g.lazy_path
require("lazy").setup({
  defaults = {
    lazy = true,
  },
  dev = {
    -- reuse files from pkgs.vimPlugins.*
    path = lazy_path,
    patterns = { "." },
    -- fallback to download
    fallback = false,
  },
  install = {
    missing = false
  },
  spec = {
    require "plugins.alpha",
    require "plugins.buffer",
    require "plugins.cmp",
    require "plugins.colorscheme",
    require "plugins.comment",
    require "plugins.direnv",
    require "plugins.git",
    require "plugins.lsp",
    require "plugins.lualine",
    require "plugins.misc",
    require "plugins.noice",
    require "plugins.none-ls",
    require "plugins.nvim-tree",
    require "plugins.telescope",
    require "plugins.toggle-term",
    require "plugins.treesitter",
    require "plugins.whichkey",
    require "plugins.zenmode",
  },
})

vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
