-- lua/kb/snippets/markdown.lua
-- Self-registering: require("kb.snippets.markdown") once after luasnip loads

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {

  -- ── Content scaffolding (no frontmatter) ───────────

  s("kbnote", fmt([[
# Goal
- {}

# TL;DR (write at end)
- {}

# Glossary hits
- **{}** (<concept/{}>): {}

# Notes
## {}
- **Def**: {}
  - Intuition: {}

# Questions
- {}

# Outbox
## Definitions to promote
## Results to promote
## Examples to save
]], {
    i(1, "what am I extracting?"),
    i(2),
    i(3, "Term"),
    i(4, "term-slug"),
    i(5, "one-line meaning"),
    i(6, "section"),
    i(7),
    i(8),
    i(0),
  })),

  s("kbconcept", fmt([[
# One-liner
{}

# Definition
{}

# Intuition
{}

# Examples
- {}

# See also
- {}
]], {
    i(1),
    i(2),
    i(3),
    i(4),
    i(0),
  })),

  s("kbmoc", fmt([[
# Scope
{}

# Index
## {}
- {}

# Inbox
- {}
]], {
    i(1, "what this covers"),
    i(2, "section"),
    i(3),
    i(0),
  })),

  s("kbresult", fmt([[
# Statement
{}

# Proof sketch
{}

# Why it matters
{}

# Depends on
- {}
]], {
    i(1),
    i(2),
    i(3),
    i(0),
  })),

  -- ── Inline refs ────────────────────────────────────

  s("cr", fmt('<concept/{}>', { i(1) })),
  s("rref", fmt('<result/{}>', { i(1) })),
  s("sr", fmt('<source/{}>', { i(1) })),
  s("nr", fmt('<note/{}>', { i(1) })),

  -- ── Quick blocks ───────────────────────────────────

  s("def", fmt([[
- **Def**: {}
  - Intuition: {}
  - Links: {}
]], { i(1), i(2), i(0) })),

  s("prop", fmt([[
- **Prop**: {}
  - Why it matters: {}
  - Proof idea: {}
  - Depends on: {}
]], { i(1), i(2), i(3), i(0) })),

  s("ex", fmt([[
- **Example**: {}
  - Setup: {}
  - Illustrates: {}
]], { i(1), i(2), i(0) })),

  s("qq", fmt([[
- **Question**: {}
  - Hypothesis: {}
  - TODO: {}
]], { i(1), i(2), i(0) })),

  -- ── Math ───────────────────────────────────────────

  s("dm", fmt("$$ {} $$", { i(1) })),
  s("im", fmt("${}$", { i(1) })),
  s("ra", { t("$\\rightarrow$") }),
  s("la", { t("$\\leftarrow$") }),
})
