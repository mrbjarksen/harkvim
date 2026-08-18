require'ibl'.setup {
  scope = {
    show_start = false,
    show_end = false,
  },
  exclude = {
    filetypes = { 'qf', 'help', 'man', 'neo-tree' },
    buftypes = { 'terminal', 'nofile', 'quickfix', 'prompt' },
  },
}
