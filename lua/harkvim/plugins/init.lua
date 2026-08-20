local load = require 'harkvim.plugins.load'

-- Color Schemes
load:plugin('tokyonight.nvim'):immediately_after('ColorSchemePre', { pattern = 'tokyonight*' })
load:plugin('catppuccin-nvim'):immediately_after('ColorSchemePre', { pattern =  'catppuccin*' })

-- UI Elements
load:plugin('nvim-web-devicons'):soon_after('UIEnter')
load:plugin('heirline.nvim'):soon_after('UIEnter')
load:plugin('nvim-notify'):soon_after('UIEnter')
load:plugin('dressing.nvim'):soon_after('UIEnter')

-- Non-essential 
load:plugin('telescope.nvim'):soon()
load:plugin('neo-tree.nvim'):soon()

-- Buffer-specific
load:plugin('indent-blanklines.nvim'):soon_after('BufRead')
load:plugin('gitsigns.nvim'):soon_after('BufRead')
load:plugin('nvim-treesitter'):soon_after('FileType')
load:plugin('nvim-lspconfig'):soon_after('FileType')
load:plugin('fidget.nvim'):soon_after('LspAttach')

-- Mode-specific
load:plugin('better-escape.nvim'):soon_after('ModeChanged')
load:plugin('nvim-autopairs'):soon_after('InsertEnter')
load:plugin('nvim-surround'):soon_after('ModeChanged')
load:plugin('vim-cool'):soon_after('CmdlineEnter')
