vim.api.nvim_create_user_command('W',   'w',   {})
vim.api.nvim_create_user_command('Q',   'q',   {})
vim.api.nvim_create_user_command('Wq',  'wq',  {})
vim.api.nvim_create_user_command('Qa',  'qa',  {})
vim.api.nvim_create_user_command('Wqa', 'wqa', {})

vim.api.nvim_create_user_command(
  'Reindent',
  function (o)
    require'harkvim.functions'.reindent(tonumber(o.args), o.line1, o.line2, o.bang)
  end,
  { nargs = 1, range = '%', bang = true, desc = "Reindent range and set options accordingly" }
)

vim.api.nvim_create_user_command(
  'Pin',
  function (o)
    local height = o.line2 - o.line1 + 1
    if not height > 0 then
      vim.notify("Could not find range to pin", vim.log.levels.ERROR)
      return
    end

    local width = 0
    local leftcol = math.huge
    local lines = vim.api.nvim_buf_get_lines(0, o.line1, o.line2 + 1, false)
    for _, line in ipairs(lines) do
      local leading = line:match('^%s*')
      line = line:gsub('%s*$', '')
      width = math.max(width, vim.fn.strdisplaywidth(line))
      leftcol = math.min(leftcol, vim.fn.strdisplaywidth(leading))
    end
    width = width - leftcol
    if not (width > 0) then
      vim.notify("Could not find range to pin", vim.log.levels.ERROR)
      return
    end

    local nw_corner = { o.line1, leftcol }
    require'harkvim.functions'.pin(nw_corner, width, height)
  end,
  { range = true, desc = 'Pin range to corner' }
)

local vertical_help = vim.api.nvim_create_augroup('harkvim.qol.vertical_help', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vertical_help,
  callback = function (a)
    local buftype = vim.bo[a.buf].buftype
    if buftype == 'help' or buftype == 'man' then
      if vim.o.columns >= 180 then
        vim.cmd.wincmd 'L'
        vim.api.nvim_win_set_config(0, { width = 82 })
      end
      vim.bo.wrapmargin = 82
      vim.wo.scrolloff = 1
      vim.wo.sidescrolloff = 0
      vim.wo.cursorline = false
      vim.wo.winfixheight = true
      vim.wo.winfixwidth = true
    end
  end
})
