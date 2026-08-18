require'catppuccin'.setup {
  styles = { conditionals = {} },
  custom_highlights = function (c)
    return {
      Cursor = { reverse = true, fg = 'NONE', bg = 'NONE' },
      Hidden = { reverse = true, blend = 100 },

      NormalMode = { fg = c.blue },
      VisualMode = { fg = c.mauve },
      SelectMode = { fg = c.mauve },
      InsertMode = { fg = c.green },
      ReplaceMode = { fg = c.red },
      CommandMode = { fg = c.blue },
      InputMode = { fg = c.blue },
      ExternalMode = { fg = c.blue },
      TerminalMode = { fg = c.green },

      CursorLineNr = { fg = c.overlay0 },
    }
  end,
}
