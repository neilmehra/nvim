-- pywal palette as ground truth + explicit per-syntax-group highlights
-- so code is readable but every color is literally from ~/.cache/wal/colors

return {
  {
    "uZer/pywal16.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("pywal16")

      -- read pywal palette (set via colors-wal.vim as g:color0..g:color15)
      local p = {}
      for i = 0, 15 do
        p[i] = vim.g["color" .. i] or vim.g["terminal_color_" .. i] or "NONE"
      end
      p.bg = vim.g.background or p[0]
      p.fg = vim.g.foreground or p[7]
      -- semantic aliases (against our rose-on-black palette):
      -- 0 black/bg, 1 dim purple, 2 deep magenta, 3 raspberry,
      -- 4 rose, 5 muted purple, 6 vivid pink, 7 cream/fg, 8 dim pink-gray
      local C = {
        bg      = p.bg,   -- tinted dark from kmeans (~#14020D)
        fg      = p.fg,
        dim     = p[8],
        mute    = p[5],
        accent  = p[6],
        rose    = p[4],
        deep    = p[3],
        magenta = p[2],
        cream   = p[7],
      }

      local hl = function(g, o) vim.api.nvim_set_hl(0, g, o) end

      -- base
      hl("Normal",        { fg = C.fg, bg = "NONE" })
      hl("NormalNC",      { fg = C.fg, bg = "NONE" })
      hl("NormalFloat",   { fg = C.fg, bg = "NONE" })
      hl("FloatBorder",   { fg = C.mute, bg = "NONE" })
      hl("WinSeparator",  { fg = C.mute, bg = "NONE" })
      hl("LineNr",        { fg = C.mute })
      hl("CursorLine",    { bg = "#0a0510" })
      hl("CursorLineNr",  { fg = C.accent, bold = true })
      hl("Visual",        { bg = "#4a1f3d" })
      hl("Search",        { fg = C.bg, bg = C.accent })
      hl("CurSearch",     { fg = C.bg, bg = C.rose, bold = true })
      hl("MatchParen",    { fg = C.accent, bold = true, underline = true })

      -- classic syntax (covers older highlighters)
      hl("Comment",       { fg = C.mute, italic = true })
      hl("String",        { fg = C.cream })
      hl("Character",     { fg = C.cream })
      hl("Number",        { fg = C.rose })
      hl("Float",         { fg = C.rose })
      hl("Boolean",       { fg = C.deep, bold = true })
      hl("Constant",      { fg = C.deep })
      hl("Identifier",    { fg = C.fg })
      hl("Function",      { fg = C.rose })
      hl("Keyword",       { fg = C.accent, bold = true })
      hl("Statement",     { fg = C.accent, bold = true })
      hl("Conditional",   { fg = C.accent, bold = true })
      hl("Repeat",        { fg = C.accent, bold = true })
      hl("Label",         { fg = C.accent })
      hl("Operator",      { fg = C.magenta })
      hl("Exception",     { fg = C.accent, bold = true })
      hl("PreProc",       { fg = C.deep })
      hl("Include",       { fg = C.accent, italic = true })
      hl("Define",        { fg = C.accent, italic = true })
      hl("Macro",         { fg = C.deep })
      hl("Type",          { fg = C.deep })
      hl("StorageClass",  { fg = C.deep, italic = true })
      hl("Structure",     { fg = C.deep })
      hl("Typedef",       { fg = C.deep })
      hl("Special",       { fg = C.accent })
      hl("Delimiter",     { fg = C.dim })
      hl("Todo",          { fg = C.bg, bg = C.accent, bold = true })

      -- treesitter (modern @-captures override the classic ones)
      hl("@variable",            { fg = C.fg })
      hl("@variable.parameter",  { fg = C.cream, italic = true })
      hl("@variable.member",     { fg = C.rose })
      hl("@variable.builtin",    { fg = C.deep, italic = true })
      hl("@property",            { fg = C.rose })
      hl("@function",            { fg = C.rose })
      hl("@function.call",       { fg = C.rose })
      hl("@function.method",     { fg = C.rose })
      hl("@function.builtin",    { fg = C.accent, italic = true })
      hl("@function.macro",      { fg = C.accent, italic = true })
      hl("@constructor",         { fg = C.deep })
      hl("@type",                { fg = C.deep })
      hl("@type.builtin",        { fg = C.deep, italic = true })
      hl("@type.definition",     { fg = C.deep, bold = true })
      hl("@keyword",             { fg = C.accent, bold = true })
      hl("@keyword.return",      { fg = C.accent, bold = true })
      hl("@keyword.function",    { fg = C.accent, bold = true })
      hl("@keyword.operator",    { fg = C.accent })
      hl("@keyword.import",      { fg = C.accent, italic = true })
      hl("@string",              { fg = C.cream })
      hl("@string.escape",       { fg = C.accent, bold = true })
      hl("@string.special",      { fg = C.accent })
      hl("@number",              { fg = C.rose })
      hl("@boolean",             { fg = C.deep, bold = true })
      hl("@constant",            { fg = C.deep })
      hl("@constant.builtin",    { fg = C.deep, bold = true })
      hl("@operator",            { fg = C.magenta })
      hl("@punctuation",         { fg = C.dim })
      hl("@punctuation.bracket", { fg = C.dim })
      hl("@punctuation.delimiter", { fg = C.dim })
      hl("@comment",             { fg = C.mute, italic = true })
      hl("@tag",                 { fg = C.accent })
      hl("@tag.attribute",       { fg = C.rose, italic = true })
      hl("@label",               { fg = C.accent })

      -- diagnostics — use palette tones
      hl("DiagnosticError",      { fg = "#ff6b9d" })
      hl("DiagnosticWarn",       { fg = C.accent })
      hl("DiagnosticInfo",       { fg = C.rose })
      hl("DiagnosticHint",       { fg = C.mute })
      hl("DiagnosticUnderlineError", { sp = "#ff6b9d", undercurl = true })
      hl("DiagnosticUnderlineWarn",  { sp = C.accent, undercurl = true })

      -- telescope
      hl("TelescopeBorder",        { fg = C.mute, bg = "NONE" })
      hl("TelescopeNormal",        { bg = "NONE" })
      hl("TelescopePromptBorder",  { fg = C.accent, bg = "NONE" })
      hl("TelescopePromptNormal",  { bg = "NONE" })
      hl("TelescopePromptPrefix",  { fg = C.accent })
      hl("TelescopeSelection",     { fg = C.fg, bg = "#1a0d20", bold = true })
      hl("TelescopeMatching",      { fg = C.accent, bold = true })
      hl("TelescopeTitle",         { fg = C.accent, bold = true })

      -- git signs
      hl("GitSignsAdd",            { fg = C.rose })
      hl("GitSignsChange",         { fg = C.accent })
      hl("GitSignsDelete",         { fg = "#ff6b9d" })
    end,
  },
}
