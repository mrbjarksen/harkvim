local leader = '<Space>'
vim.keymap.set('', leader, '')
vim.g.mapleader = vim.keycode(leader)

vim.api.nvim_create_autocmd('UIEnter', {
  callback = function ()
    pcall(vim.cmd.colorscheme, 'catppuccin-mocha')
  end,
  once = true,
  nested = true,
})

require 'harkvim.plugins'

require 'harkvim.options'
require 'harkvim.keymaps'.basic()
require 'harkvim.qol'
require 'harkvim.cursorline'
require 'harkvim.folds'
require 'harkvim.diagnostics'
require 'harkvim.lsp'
require 'harkvim.treesitter'
