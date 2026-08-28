local M = {}

M.configure = function (winid, bufnr)
  local next = next -- namespace lookup optimization
  winid = winid or 0
  bufnr = bufnr or vim.api.nvim_win_get_buf(winid)

  -- Prefer LSP folding if available
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/foldingRange' })
  if next(clients) then
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    return
  end

  -- Use tree-sitter folding otherwise if available
  if pcall(vim.treesitter.get_parser, bufnr) then
    vim.wo[winid][0].foldmethod = 'expr'
    vim.wo[winid][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    return
  end

  vim.wo[winid][0].foldmethod = 'indent'
  vim.wo[winid][0].foldexpr = ''
end

vim.opt.fillchars:append {
  fold = ' ',
  foldopen = require'harkvim.icons'.misc.expanded,
  foldclose = require'harkvim.icons'.misc.collapsed,
  foldsep = ' ',
}

vim.o.foldtext = ''
vim.o.foldmethod = 'indent'
vim.o.foldexpr = ''
vim.o.foldlevel = 99

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('harkvim.folds.foldexpr', { clear = true }),
  callback = function (a) M.configure(nil, a.buf) end
})

return M
