-- lua/kb/snippets/markdown.lua
-- Generic markdown helpers for the KB. No type-specific scaffolds.

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
  -- Inline entity ref
  s("er", fmt("<entity/{}>", { i(1) })),

  -- Math
  s("dm", fmt("$$ {} $$", { i(1) })),
  s("im", fmt("${}$", { i(1) })),
  s("ra", { t("$\\rightarrow$") }),
  s("la", { t("$\\leftarrow$") }),
})
