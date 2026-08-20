vim.api.nvim_create_autocmd('FileType', {
  callback = function (a)
    vim.schedule(function ()
      if pcall(vim.treesitter.start, a.buf) then
        if vim.bo.indentexpr == '' then
          vim.bo.indentexpr = vim.bo.indentexpr or 'v:lua.require("nvim-treesitter").indentexpr()'
        end
      end
    end)
  end,
})
