local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'

local function rgb(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

local function blend(a, b, alpha)
  local color_a = rgb(a)
  local color_b = rgb(b)

  local blendChannel = function(i)
    local ret = (alpha * color_a[i] + ((1 - alpha) * color_b[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

local function setup_colors()
  local colors = {
    fg = string.format('#%06x', utils.get_highlight('StatusLineNC').fg),
    bg = string.format('#%06x', utils.get_highlight('StatusLineNC').bg),
    none = string.format('#%06x', utils.get_highlight('Normal').bg),
  }

  local mode_highlights = {
    'NormalMode',
    'VisualMode',
    'SelectMode',
    'InsertMode',
    'ReplaceMode',
    'CommandMode',
    'InputMode',
    'ExternalMode',
    'TerminalMode'
  }

  for _, mode in ipairs(mode_highlights) do
    colors[mode] = string.format('#%06x', utils.get_highlight(mode).fg)
    colors[mode .. 'Faded'] = blend(colors[mode], colors.bg, 0.15)
  end

  return colors
end

require'heirline'.load_colors(setup_colors)

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = "Heirline",
})

---- Mode indicator ----

local Mode = {
  condition = function ()
    return conditions.is_active()
  end,
  static = {
    mode_names = {
      ['n'] = 'NORMAL',
      ['no'] = 'NORMAL',
      ['nov'] = 'NORMAL',
      ['noV'] = 'NORMAL',
      ['no\22'] = 'NORMAL',
      ['niI'] = 'NORMAL [CTRL-O]',
      ['niR'] = 'NORMAL [CTRL-O]',
      ['niV'] = 'NORMAL [CTRL-O]',
      ['nt'] = 'NORMAL',
      ['v'] = 'VISUAL',
      ['vs'] = 'VISUAL [CTRL-O]',
      ['V'] = 'VISUAL LINE',
      ['Vs'] = 'VISUAL LINE [CTRL-O]',
      ['\22'] = 'VISUAL BLOCK',
      ['\22s'] = 'VISUAL BLOCK [CTRL-O]',
      ['s'] = 'SELECT',
      ['S'] = 'SELECT LINE',
      ['\19'] = 'SELECT BLOCK',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['ix'] = 'INSERT',
      ['R'] = 'REPLACE',
      ['Rc'] = 'REPLACE',
      ['Rx'] = 'REPLACE',
      ['Rv'] = 'REPLACE',
      ['Rcv'] = 'REPLACE',
      ['Rxv'] = 'REPLACE',
      ['c'] = 'COMMAND',
      ['cv'] = 'EX',
      ['r'] = 'PROMPT',
      ['rm'] = 'PROMPT',
      ['r?'] = 'PROMPT',
      ['!'] = 'EXTERNAL',
      ['t'] = 'TERMINAL',
    },
  },
  provider = function (self)
    return " " .. self.mode_names[self.mode] .. " "
  end,
  hl = function (self)
    local color = self:mode_color()
    return { fg = color .. 'Faded', bg = color, bold = true }
  end,
  update = { 'ModeChanged', 'BufEnter', 'CmdlineLeave' },
}

---- File information ----

local FileRO = {
  provider = function ()
    if vim.bo.readonly then return ' RO▕ ' end
    return ' '
  end
}

local FileIcon = {
  init = function (self)
    local extension = vim.fn.fnamemodify(self.filename, ':e')
    self.icon, self.icon_color = require'nvim-web-devicons'.get_icon_color(self.filename, extension, { default = true })
  end,
  provider = function (self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function (self) return { fg = self.icon_color } end,
}

local FileName = {
  provider = function (self)
    local filename = vim.fn.fnamemodify(self.filename, ':.')
    if filename == '' then return '[No Name]' end
    if not conditions.width_percent_below(#filename, 0.25) or vim.bo.filetype == 'help' then
      filename = vim.fn.fnamemodify(self.filename, ':t')
    end
    if vim.w.neo_tree_preview == 1 then
      filename = "[" .. filename .. "]"
    end
    return filename
  end,
}

local FileModified = {
  provider = function (self)
    if not vim.bo.modifiable then return '▕ - ' end
    if vim.bo.modified then return '▕ + ' end
    return ' '
  end
}

local File = {
  init = function (self) self.filename = vim.api.nvim_buf_get_name(0) end,
  hl = function (self)
    local color = self:mode_color()
    if not conditions.is_active() then return { fg = 'NormalMode', bg = 'bg' } end
    return { fg = color, bg = color .. 'Faded' }
  end,
}

File = utils.insert(File, FileRO, FileIcon, FileName, FileModified)

---- Location ----

local Percent = {
  provider = ' %3p%% ',
  hl = function (self)
    local color = self:mode_color()
    if not conditions.is_active() then return { fg = 'fg', bg = 'bg' } end
    return { fg = color, bg = color .. 'Faded' }
  end
}

local Cursor = {
  provider = ' %3l:%-2c ',
  hl = function (self)
    local color = self:mode_color()
    if not conditions.is_active() then return { fg = 'fg', bg = 'bg' } end
    return { fg = color .. 'Faded', bg = color }
  end,
}

---- Info ----

local Showcmd = { provider = '%S', update = { 'CmdlineEnter', 'CmdlineLeave', 'CmdlineChanged' } }
local Filetype = { provider = function () return vim.bo.ft ~= '' and vim.bo.ft or 'no ft' end }
local Encoding = { provider = function () return vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc end }
local FileFormat = { provider = function () return vim.bo.fileformat end }

local Seperator = { provider = '▕ ' }
local Space = { provider = ' ' }

local Info = {
  condition = function () return conditions.is_active() end,
  hl = { fg = 'fg', bg = 'bg' },
  Showcmd, Space, FileFormat, Seperator, Encoding, Seperator, Filetype, Space
}

---- Full statusline ----

local Align = { provider = '%<%=' }

local StatusLine = {
  condition = function ()
    return not conditions.buffer_matches {
      filetype = { 'neo-tree' },
    }
  end,
  init = function (self)
    if not self.once then
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = '*:*o*',
        command = 'redrawstatus',
      })
      self.once = true
    end
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_colors = {
      ['n'] = 'NormalMode',
      ['v'] = 'VisualMode',
      ['V'] = 'VisualMode',
      ['\22'] = 'VisualMode',
      ['s'] = 'SelectMode',
      ['S'] = 'SelectMode',
      ['\19'] = 'SelectMode',
      ['i'] = 'InsertMode',
      ['R'] = 'ReplaceMode',
      ['c'] = 'CommandMode',
      ['r'] = 'InputMode',
      ['!'] = 'ExternalMode',
      ['t'] = 'TerminalMode',
    },
    mode_color = function (self)
      local mode = conditions.is_active() and self.mode or 'n'
      return self.mode_colors[self.mode:sub(1, 1)]
    end
  },
}

StatusLine = utils.insert(StatusLine,
  Mode, File,
  Align,
  Showcmd, Info, Percent, Cursor
)

require'heirline'.setup {
  statusline = StatusLine
}
