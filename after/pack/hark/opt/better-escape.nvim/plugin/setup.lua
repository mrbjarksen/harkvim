require'better_escape'.setup {
  timeout = 30,
  default_mappings = false,
  mappings = {
    n = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
    i = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
    c = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
    t = { j = { k = '<Esc>' }, k = { j = '<Esc>' } },
  },
}
