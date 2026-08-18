require'gitsigns'.setup {
  signs = {
    add          = { text = '▎' },
    change       = { text = '▎' },
    delete       = { text = '🬽' },
    topdelete    = { text = '🭘' },
    changedelete = { text = '▎' },
  },
  trouble = false,
  on_attach = require'harkvim.keymaps'.gitsigns
}
