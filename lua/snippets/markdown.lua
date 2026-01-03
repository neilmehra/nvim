-- lua/snippets/markdown.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function default_title()
  local base = vim.fn.expand("%:t:r")
  return (base:gsub("[-_]+", " "))
end

local function today()
  return os.date("%Y-%m-%d")
end

ls.add_snippets("markdown", {
  -- tiny helpers
  s("ra", { t("$\\rightarrow$") }),
  s("la", { t("$\\leftarrow$") }),

  -- rough scratch note
  s("rough", fmt([[
# {}

**Status:** {}
**Date:** {}

## TL;DR
- {}

## Notes
- {}

## Questions / TODO
- {}

## Links
- KB: {}
- Related: {}
]], {
    i(1, default_title()),
    i(2, "draft"),
    f(function() return today() end, {}),
    i(3),
    i(4),
    i(5),
    i(6, "kb:note/"),
    i(0),
  })),

  -- concept note
  s("concept", fmt([[
# {}

**One-liner:** {}

## Definition
{}

## Intuition
{}

## Key properties
- {}

## Examples
- {}

## Related
- {}

## Sources
- {}
]], {
    i(1, default_title()),
    i(2),
    i(3),
    i(4),
    i(5),
    i(6),
    i(7),
    i(0),
  })),

  -- map of content
  s("moc", fmt([[
# MOC: {}

**Purpose:** {}

## Core threads
- {}

## Navigation
### Concepts
- {}

### People
- {}

### Orgs
- {}

### Projects / Artifacts
- {}

## Inbox
- {}
]], {
    i(1, default_title()),
    i(2),
    i(3),
    i(4),
    i(5),
    i(6),
    i(7),
    i(0),
  })),
})
