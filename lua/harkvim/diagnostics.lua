local icons = require'harkvim.icons'.diagnostics

vim.diagnostic.config {
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.INFO] = icons.info,
      [vim.diagnostic.severity.HINT] = icons.hint,
    }
  },
  float = {
    focusable = false,
    header = '',
    prefix = '',
  },
  update_in_insert = true,
  severity_sort = true,
}

require'harkvim.keymaps'.diagnostics()
