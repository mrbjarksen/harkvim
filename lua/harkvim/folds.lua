vim.opt.fillchars:append {
  fold = ' ',
  foldopen = require'harkvim.icons'.misc.expanded,
  foldclose = require'harkvim.icons'.misc.collapsed,
  foldsep = ' ',
}

vim.o.foldtext = ''

vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('harkvim.folds.foldexpr', { clear = true }),
  callback = function (a)
    local next = next -- namespace lookup optimization

    -- Prefer LSP folding if available
    local clients = vim.lsp.get_clients({
      bufnr = a.buf,
      method = 'textDocument/foldingRange'
    })

    if next(clients) then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
      return
    end

    -- Use tree-sitter folding otherwise if available
    if pcall(vim.treesitter.get_parser, a.buf) then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end

    vim.wo.foldmethod = 'indent'
    vim.wo.foldexpr = ''
  end
})
