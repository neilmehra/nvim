local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function buf_basename()
  return vim.fn.expand("%:t:r")
end

local function today()
  return os.date("%Y-%m-%d")
end

local prefixes = fmt([[
@prefix kb:  <https://kb.neil.me/> .
@prefix rel: <https://kb.neil.me/rel/> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .

{}
]], { i(1) })

ls.add_snippets("ttl", {
  s("ttlprefix", prefixes),

  s("note", fmt([[
{}kb:note/{} a kb:Note ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:tag {} ;
  rel:tag {} ;
  rel:created "{}"^^xsd:date .{}

]], {
    c(1, { t(""), t(prefixes) }),
    i(2, f(buf_basename, {})),
    i(3, rep(2)),
    i(4, "notes/" .. buf_basename() .. ".md"),
    c(5, { t("kb:status/draft"), t("kb:status/seed"), t("kb:status/evergreen"), t("kb:status/stable") }),
    i(6, "kb:subject/systems"),
    f(today, {}),
    i(0),
  })),

  s("person", fmt([[
{}kb:person/{} a kb:Person ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:tag {} ;
  rel:created "{}"^^xsd:date ;
  rel:link "{}" .{}

]], {
    c(1, { t(""), t(prefixes) }),
    i(2, f(buf_basename, {})),
    i(3, "Full Name"),
    i(4, "notes/people/" .. buf_basename() .. ".md"),
    c(5, { t("kb:status/seed"), t("kb:status/evergreen"), t("kb:status/stable") }),
    f(today, {}),
    i(6, "https://"),
    i(0),
  })),

  s("org", fmt([[
{}kb:org/{} a kb:Org ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:tag {} ;
  rel:link "{}" .{}

]], {
    c(1, { t(""), t(prefixes) }),
    i(2, f(buf_basename, {})),
    i(3, "Organization Name"),
    i(4, "notes/org/" .. buf_basename() .. ".md"),
    c(5, { t("kb:status/seed"), t("kb:status/evergreen"), t("kb:status/stable") }),
    i(6, "https://"),
    i(0),
  })),

  s("concept", fmt([[
{}kb:concept/{} a kb:Concept ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:tag {} ;
  rel:created "{}"^^xsd:date ;
  rel:related {} .{}

]], {
    c(1, { t(""), t(prefixes) }),
    i(2, f(buf_basename, {})),
    i(3, "Concept Name"),
    i(4, "notes/concepts/" .. buf_basename() .. ".md"),
    c(5, { t("kb:status/seed"), t("kb:status/evergreen"), t("kb:status/stable") }),
    f(today, {}),
    i(6, "kb:concept/"),
    i(0),
  })),

  s("moc", fmt([[
{}kb:moc/{} a kb:MOC ;
  rdfs:label "{}" ;
  rel:file "{}" ;
  rel:tag kb:status/evergreen ;
  rel:tag kb:subject/{} .{}

]], {
    c(1, { t(""), t(prefixes) }),
    i(2, f(buf_basename, {})),
    i(3, "MOC: Title"),
    i(4, "notes/mocs/" .. buf_basename() .. ".md"),
    i(5, "systems"),
    i(0),
  })),
})
