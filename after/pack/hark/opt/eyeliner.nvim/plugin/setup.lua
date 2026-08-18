require'eyeliner'.setup {
  highlight_on_key = true
}

vim.api.nvim_set_hl(0, 'EyelinerPrimary', { underline = true, force = true })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = true, force = true })
