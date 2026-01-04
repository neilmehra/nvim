-- lua/snippets/ttl.lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

local function buf_basename()
  return vim.fn.expand("%:t:r")
end

local function today()
  return os.date("%Y-%m-%d")
end

local function prefixes_node()
  return fmt([[
@base <https://kb.neil.me/> .
@prefix kb:  <https://kb.neil.me/> .
@prefix rel: <https://kb.neil.me/rel/> .
@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

{}
]], { i(1) })
end

ls.add_snippets("ttl", {
  s("ttlprefix", prefixes_node()),

  -- NOTE TTL (graph anchor + file jump + minimal metadata)
  s("kbnote", fmt([[
{}<note/{}> a kb:Note ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/{}> ;
  rel:tag <subject/{}> ;
  rel:source <source/{}> ;
  rel:section <section/{}> .{}

]], {
    c(1, { t(""), prefixes_node() }),

    i(2, f(buf_basename, {})),
    i(3, f(buf_basename, {})),

    f(function() return "notes/" .. buf_basename() .. ".md" end, {}),
    f(today, {}),

    c(4, { t("draft"), t("seed"), t("evergreen"), t("stable") }),
    i(5, "systems"),
    i(6, "aluffi-algebra"),
    i(7, "aluffi-0.1"),

    i(0),
  })),

  -- CONCEPT TTL
  s("kbconcept", fmt([[
{}<concept/{}> a kb:Concept ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/{}> ;
  rel:tag <subject/{}> .{}

]], {
    c(1, { t(""), prefixes_node() }),

    i(2, f(buf_basename, {})),
    i(3, "Concept Name"),

    f(function() return "notes/concepts/" .. buf_basename() .. ".md" end, {}),
    f(today, {}),

    c(4, { t("seed"), t("evergreen"), t("stable") }),
    i(5, "math"),

    i(0),
  })),

  -- MOC TTL
  s("kbmoc", fmt([[
{}<moc/{}> a kb:MOC ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/evergreen> ;
  rel:tag <subject/{}> .{}

]], {
    c(1, { t(""), prefixes }),

    i(2, f(buf_basename, {})),
    i(3, "MOC: Title"),

    f(function() return "notes/mocs/" .. buf_basename() .. ".md" end, {}),
    f(today, {}),

    i(4, "systems"),

    i(0),
  })),
})
