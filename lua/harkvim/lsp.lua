local group = vim.api.nvim_create_augroup('harkvim.lsp', { clear = true })
local document_highlight_group = vim.api.nvim_create_augroup('harkvim.lsp.document_highlight', { clear = false })

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function (a)
    vim.schedule(function ()
      for _, config in ipairs(vim.lsp.get_configs { enabled = false, filetype = a.match }) do
        if type(config.cmd) ~= 'table' or vim.fn.executable(config.cmd[1]) == 1 then
          vim.lsp.enable(config.name)
        end
      end
    end)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function (a)
    require'harkvim.keymaps'.lsp(a.buf)

    local client = assert(vim.lsp.get_client_by_id(a.data.client_id))

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, a.buf, { autotrigger = true })
    end

    if client:supports_method('textDocument/linkedEditingRange') then
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end

    if client:supports_method('textDocument/codeLens') then
      vim.lsp.codelens.enable(true, { bufnr = a.buf, client_id = client.id })
    end

    if client:supports_method('textDocument/semanticTokens') then
      vim.lsp.semantic_tokens.enable(true, { bufnr = a.buf, client_id = client.id })
    end

    if client:supports_method('textDocument/foldingRange') then
      vim.wo[0][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method('textDocument/documentHighlight') then
      vim.api.nvim_clear_autocmds { buffer = a.buf, group = document_highlight_group }
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = document_highlight_group,
        buffer = a.buf,
        callback = vim.lsp.buf.document_highlight
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
        group = document_highlight_group,
        buffer = a.buf,
        callback = vim.lsp.buf.clear_references
      })
    end
  end
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = group,
  callback = function (a)
    local client = assert(vim.lsp.get_client_by_id(a.data.client_id))

    vim.lsp.completion.enable(false, client.id, a.buf)
    vim.lsp.codelens.enable(false, { bufnr = a.buf, client_id = client.id })
    vim.lsp.semantic_tokens.enable(false, { bufnr = a.buf, client_id = client.id })

    vim.schedule(function()
      require'harkvim.folds'.configure(nil, a.buf)
    end)

    vim.api.nvim_clear_autocmds { buffer = a.buf, group = document_highlight_group }
  end
})
