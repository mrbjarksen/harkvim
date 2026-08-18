vim.api.nvim_create_autocmd('FileType', {
  callback = function (a)
    for _, config in ipairs(vim.lsp.get_configs { filetype = a.match }) do
      vim.lsp.enable(config.name)
    end
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('harkvim.lsp.attach', { clear = true }),
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
      vim.lsp.codelens.enable(true, { client_id = client.id })
    end

    if client:supports_method('textDocument/semanticTokens') then
      vim.lsp.semantic_tokens.enable(true, { client_id = client.id })
    end

    if client:supports_method('textDocument/foldingRange') then
      vim.wo[0][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method('textDocument/documentHighlight') then
      local document_highlight_group = vim.api.nvim_create_augroup('harkvim.lsp.document_highlight', { clear = false })
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
