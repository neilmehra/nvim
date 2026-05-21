vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.fileencoding = "utf-8"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.mouse = ""
vim.opt.pumheight = 10
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.ea = false
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.shortmess:append("c")
vim.opt.guifont = "JetBrainsMono Nerd Font:h13"

-- chrome reduction: cmdline owned by noice (popup), no mode echo, no ruler
vim.opt.cmdheight   = 0     -- bottom cmdline vanishes when idle
vim.opt.showmode    = false -- mode shown by cursor shape only
vim.opt.showcmd     = false
vim.opt.ruler       = false
vim.opt.showtabline = 0     -- never show tabline
vim.opt.laststatus  = 3     -- one global statusline, even with splits

-- gutter: stable single-col, tighter number gutter
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.numberwidth    = 3
vim.opt.signcolumn     = "yes:1"
vim.opt.cursorline     = true
vim.opt.cursorlineopt  = "number"  -- only the number highlights, not the whole row
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8

-- minimal divider chars: thin vertical, blank EOB, blank fold col
vim.opt.fillchars:append({
  eob       = " ",   -- no ~ on empty lines
  vert      = "│",
  vertleft  = "│",
  vertright = "│",
  horiz     = "─",
  horizup   = "─",
  horizdown = "─",
  fold      = " ",
  foldsep   = " ",
  foldopen  = "▾",
  foldclose = "▸",
  diff      = "╱",
})

-- cursor shapes encode mode (so we can drop the lualine mode label)
vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor",
  "i-ci-ve:ver25-Cursor",
  "r-cr:hor20-Cursor",
  "o:hor50-Cursor",
  "a:blinkwait300-blinkon200-blinkoff150",
}, ",")
