-- lua/kb/snippets/turtle.lua
-- Self-registering: just require("kb.snippets.turtle") once after luasnip loads

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local function slug()
  return vim.fn.expand("%:t:r")
end

local function label()
  return (slug():gsub("%-", " "):gsub("^%l", string.upper))
end

local function today()
  return os.date("%Y-%m-%d")
end

local function mdpath()
  local p = vim.fn.expand("%:p")
  if p:match("/kg/concepts/") then
    return "concepts/" .. slug() .. ".md"
  elseif p:match("/kg/mocs/") then
    return "mocs/" .. slug() .. ".md"
  elseif p:match("/kg/results/") then
    return "results/" .. slug() .. ".md"
  else
    return "notes/" .. slug() .. ".md"
  end
end

ls.add_snippets("turtle", {

  -- ── Entity blocks ──────────────────────────────────

  s("kbnote", fmt([[
<note/{}> a kb:Note ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/{}> ;
  rel:tag <subject/{}> ;
  rel:source <source/{}> .
]], {
    f(slug, {}),
    f(label, {}),
    f(mdpath, {}),
    f(today, {}),
    c(1, { t("draft"), t("seed"), t("stable") }),
    i(2, "math"),
    i(0, "source-slug"),
  })),

  s("kbconcept", fmt([[
<concept/{}> a kb:Concept ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <subject/{}> .
]], {
    f(slug, {}),
    f(label, {}),
    f(mdpath, {}),
    f(today, {}),
    i(0, "math"),
  })),

  s("kbmoc", fmt([[
<moc/{}> a kb:MOC ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/evergreen> ;
  rel:tag <subject/{}> .
]], {
    f(slug, {}),
    f(label, {}),
    f(mdpath, {}),
    f(today, {}),
    i(0, "math"),
  })),

  s("kbresult", fmt([[
<result/{}> a kb:Result ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <subject/{}> .
]], {
    f(slug, {}),
    f(label, {}),
    f(mdpath, {}),
    f(today, {}),
    i(0, "math"),
  })),

  s("kbsource", fmt([[
<source/{}> a kb:Source ;
  rdfs:label "{}" .
]], {
    f(slug, {}),
    f(label, {}),
  })),

  -- ── Inline relations (use inside entity blocks) ────

  s("ra", fmt('  rel:about <concept/{}> ;',   { i(1) })),
  s("ri", fmt('  rel:includes <concept/{}> ;', { i(1) })),
  s("re", fmt('  rel:explains <concept/{}> ;', { i(1) })),
  s("rs", fmt('  rel:source <source/{}> ;',    { i(1) })),
  s("rt", fmt('  rel:tag <subject/{}> ;',      { i(1) })),
  s("rq", fmt('  rel:requires <concept/{}> ;', { i(1) })),
  s("rn", fmt('  rel:includes <note/{}> ;',    { i(1) })),
  s("rr", fmt('  rel:includes <result/{}> ;',  { i(1) })),
})
