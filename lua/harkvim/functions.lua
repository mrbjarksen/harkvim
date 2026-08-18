return {
  ---Reindent lines and set 'shiftwidth'
  ---(and optionally 'tabstop') accordingly.
  ---Also appropriately formats leading whitespace
  ---w.r.t. the values of 'tabstop' and 'expandtab'.
  reindent = function (size, line1, line2, set_tabstop)
    local tabstop = vim.api.nvim_get_option_value('tabstop', {})
    local _shiftwidth = vim.api.nvim_get_option_value('shiftwidth', {})
    local shiftwidth
    if _shiftwidth == 0 then shiftwidth = tabstop else shiftwidth = _shiftwidth end
    set_tabstop = set_tabstop or _shiftwidth == 0

    local lines = vim.api.nvim_buf_get_lines(0, line1-1, line2, true)
    for i = 1, #lines do
      local wsi, wsj = lines[i]:find('^[ \t]*')
      local spaces = 0
      for j = wsi, wsj do
        local shift = 1
        if lines[i]:sub(j, j) == '\t' then shift = tabstop - (spaces % tabstop) end
        spaces = spaces + shift
      end
      local shifts = math.floor(spaces/shiftwidth)
      spaces = spaces % shiftwidth

      local ws
      if set_tabstop and not vim.api.nvim_get_option_value('expandtab', {}) then
        ws = ('\t'):rep(shifts) .. (' '):rep(spaces)
      else
        ws = (' '):rep(shifts * size + spaces)
        if not vim.api.nvim_get_option_value('expandtab', {}) then
          ws = ws:gsub((' '):rep(tabstop), '\t')
        end
      end

      lines[i] = ws .. lines[i]:sub(wsj+1, -1)
    end

    vim.api.nvim_buf_set_lines(0, line1-1, line2, true, lines)
    if _shiftwidth ~= 0 then vim.bo.shiftwidth = size end
    if set_tabstop then vim.bo.tabstop = size end
  end,

  ---Toggle relative line numbers
  show_relativenumber = function ()
    -- Cancel if already invoked
    if vim.wo.relativenumber then
      vim.wo.relativenumber = false
      pcall(vim.api.nvim_del_augroup_by_name, 'harkvim.relativenumber')
      return
    end

    vim.wo.relativenumber = true
    vim.api.nvim_create_augroup('harkvim.relativenumber', { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter' }, {
      group = 'harkvim.relativenumber',
      desc = "Disable relative line numbers",
      callback = function ()
        vim.wo.relativenumber = false
        vim.api.nvim_del_augroup_by_name 'harkvim.relativenumber'
      end
    })
  end,

  ---Toggle virtual text for diagnostics
  toggle_diag_virt_text = function ()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config { virtual_text = not current }
  end,

  ---Toggle virtual text for diagnostics
  toggle_diag_virt_lines = function ()
    local current = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config { virtual_lines = not current }
  end,

  ---Toggle underline for diagnostics
  toggle_diag_underline = function ()
    local current = vim.diagnostic.config().underline
    vim.diagnostic.config { underline = not current }
  end,

  pin = function (nw_corner, width, height)
    local winid = vim.api.nvim_open_win(0, false, {
      relative = 'editor',
      anchor = 'NE',
      width = width,
      height = height,
      row = 0.5,
      col = 0.5,
      -- focusable = false,
      zindex = 1,
      style = 'minimal',
      border = 'single',
    })
    vim.wo[winid].signcolumn = 'no'
    vim.api.nvim_win_call(winid, function ()
      vim.fn.winrestview {
        lnum = nw_corner[1],
        col = nw_corner[2],
        topline = nw_corner[1],
        leftcol = nw_corner[2],
      }
    end)
  end,
}
