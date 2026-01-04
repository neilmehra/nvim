-- lua/snippets/markdown.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local function buf_slug()
  -- expects filename like: aluffi-ch0-1.1-set-theory.md
  return vim.fn.expand("%:t:r")
end

local function default_title()
  local base = buf_slug()
  return (base:gsub("[-_]+", " "))
end

local function kb_id(kind)
  return "kb:" .. kind .. "/" .. buf_slug()
end

ls.add_snippets("markdown", {
  -- tiny helpers
  s("ra", { t("$\\rightarrow$") }),
  s("la", { t("$\\leftarrow$") }),

  -- READING / LINEAR NOTE (your template, trimmed to the pieces you’ll actually use)
  s("note", fmt([[
---
id: {}
title: {}
source: {}
section: {}
status: {}
---

# Goal
- {}

# TL;DR (write at end)
- {}

# Glossary hits (concept stubs)
- **{}** (<concept/{}>): {}

# Notes (linear as you read)
## ...  <!-- e.g. p.12–14 / §1.1 -->
- [ ] **Def**: ...
  - Intuition:
  - Minimal example:
  - Non-example / edge case:
  - Links: <concept/...

- [ ] **Prop/Lemma**: ...
  - Why it matters:
  - Proof idea (1–3 bullets):
  - Depends on: <concept/...

- **Example**:
  - Setup:
  - What it illustrates:
  - Generalization?

- **Question / Confusion**:
  - What I don't get:
  - Hypothesis:
  - TODO to resolve:

# Outbox (copy/paste into concept notes later)
## Definitions to promote
- <concept/concept-slug> — rewrite def + add examples

## Results to promote (important derivations/examples)
- <result/result-slug> — statement + proof sketch + uses

## Examples to save
- Example - ...

]], {
    f(function() return kb_id("note") end, {}),
    i(1, default_title() .. " (reading)"),
    i(2, "<source/"),
    i(3, "<section/"),
    c(4, { t("draft"), t("seed"), t("evergreen"), t("stable") }),

    i(5, "What am I trying to extract?"),

    i(6, "3–7 bullets: what changed in my brain"),

    i(7, "Group"),
    i(8, "group"),
    i(9, "one-line meaning"),
  })),

  -- CONCEPT NOTE (minimal landing page + easy promotion target)
  s("concept", fmt([[
---
id: {}
title: {}
status: {}
---

# One-liner
{}

# Definition
{}

# Canonical examples
- {}
- {}

# Non-example / edge case
- {}

# Properties / hooks
- {}
- {}

# See also
- <concept/{}>
- <result/{}>

# Sources
- {}

# Inbox
- {}

]], {
    f(function() return kb_id("concept") end, {}),
    i(1, default_title()),
    c(2, { t("seed"), t("evergreen"), t("stable") }),

    i(3, "..."),

    i(4, "..."),

    i(5, "..."),
    i(6, "..."),

    i(7, "..."),

    i(8, "..."),
    i(9, "..."),

    i(10, "related-concept"),
    i(11, "related-result"),

    i(12, "..."),

    i(0, "open questions / improvements"),
  })),

  -- MOC (pure navigation + inbox; stays small, stays useful)
  s("moc", fmt([[
---
id: {}
title: {}
status: evergreen
---

# Scope
{}

# Index
## 
- <concept/{}>

# Inbox
- {}

]], {
    f(function() return kb_id("moc") end, {}),
    i(1, "MOC: " .. default_title()),
    i(2, "What this MOC covers (1–2 lines)."),
    i(3, "concept-slug"),
    i(4, "things to add/improve"),
  })),
})
