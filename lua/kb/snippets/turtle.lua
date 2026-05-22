-- lua/kb/snippets/turtle.lua
-- Generic relation snippets. All entity blocks are written by the create flow,
-- not by snippets.

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("turtle", {
  -- Type edge (rdf:type)
  s("rt", fmt("  a <entity/{}> ;", { i(1) })),

  -- Common relation edges
  s("ra", fmt("  rel:about <entity/{}> ;",       { i(1) })),
  s("re", fmt("  rel:explains <entity/{}> ;",    { i(1) })),
  s("rq", fmt("  rel:requires <entity/{}> ;",    { i(1) })),
  s("rs", fmt("  rel:source <entity/{}> ;",      { i(1) })),
  s("rc", fmt("  rel:contradicts <entity/{}> ;", { i(1) })),
  s("ri", fmt("  rel:includes <entity/{}> ;",    { i(1) })),
})
