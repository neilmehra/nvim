local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function buf_basename()
  return vim.fn.expand "%:t:r"
end

local function today()
  return os.date "%Y-%m-%d"
end

local function prefixes_node()
  return t {
    "@base <https://kb.neil.me/> .",
    "@prefix kb:  <https://kb.neil.me/> .",
    "@prefix rel: <https://kb.neil.me/rel/> .",
    "@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .",
    "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .",
    "",
    "",
  }
end

ls.add_snippets("ttl", {
  s("ttlprefix", prefixes_node()),

  -- NOTE TTL (graph anchor + file jump + minimal metadata)
  s(
    "kbnote",
    fmt(
      [[
{}<note/{}> a kb:Note ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/{}> ;
  rel:tag <subject/{}> ;
  rel:source <source/{}> .{}
]],
      {
        prefixes_node(),

        f(function()
          return buf_basename()
        end, {}),
        f(function()
          return buf_basename()
        end, {}),

        f(function()
          return "notes/" .. buf_basename() .. ".md"
        end, {}),
        f(today, {}),

        c(1, { t "draft", t "seed", t "evergreen", t "stable" }),
        i(2, "systems"),
        i(3, "aluffi-algebra"),

        i(0),
      }
    )
  ),

  -- CONCEPT TTL
  s(
    "kbconcept",
    fmt(
      [[
{}<concept/{}> a kb:Concept ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/{}> ;
  rel:tag <subject/{}> .{}

]],
      {
        prefixes_node(),

        f(function()
          return buf_basename()
        end, {}),
        i(1, "Concept Name"),

        f(function()
          return "notes/concepts/" .. buf_basename() .. ".md"
        end, {}),
        f(today, {}),

        c(2, { t "seed", t "evergreen", t "stable" }),
        i(3, "math"),

        i(0),
      }
    )
  ),

  -- MOC TTL
  s(
    "kbmoc",
    fmt(
      [[
{}<moc/{}> a kb:MOC ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:created "{}"^^xsd:date ;
  rel:tag <status/evergreen> ;
  rel:tag <subject/{}> .{}

]],
      {
        prefixes_node(),

        f(function()
          return buf_basename()
        end, {}),
        i(1, "MOC: Title"),

        f(function()
          return "notes/mocs/" .. buf_basename() .. ".md"
        end, {}),
        f(today, {}),

        i(2, "systems"),

        i(0),
      }
    )
  ),
})
