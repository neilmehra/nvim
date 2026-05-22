-- lua/kb/type.lua
-- Add a type-edge to the current entity. Picker over existing category-nodes
-- with a "create new" fallback via <C-n>.

local M = {}
local kb = require("kb")
local Slug = require("kb.slug")
local Sparql = require("kb.sparql")
local Picker = require("kb.telescope")

local function current_ttl_path()
  local p = vim.fn.expand("%:p")
  if p:match("/kg/entities/.+%.ttl$") then return p end
  if p:match("/entities/.+%.md$") then
    return p:gsub("/entities/", "/kg/entities/"):gsub("%.md$", ".ttl")
  end
  return nil
end

local function ensure_category(slug, label)
  local ttl = kb.root .. "/kg/entities/" .. slug .. ".ttl"
  if vim.fn.filereadable(ttl) == 1 then return end
  local lines = {
    "@base <https://kb.neil.me/> .",
    "@prefix rel: <https://kb.neil.me/rel/> .",
    "@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .",
    "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .",
    "",
    string.format('<entity/%s> rdfs:label "%s" ;', slug, label:gsub('"', '\\"')),
    string.format('  rel:created "%s"^^xsd:date .', os.date("%Y-%m-%d")),
    "",
  }
  local f = io.open(ttl, "w"); f:write(table.concat(lines, "\n")); f:close()
end

---Append `a <entity/{type_slug}> .` to the entity TTL at `ttl_path`.
---Converts the last `.` (entity-block terminator) into `;` and adds new clause.
local function append_type_edge(ttl_path, type_slug)
  local f = io.open(ttl_path, "r")
  if not f then return false end
  local content = f:read("*a"); f:close()
  local replacement = string.format(";\n  a <entity/%s> .", type_slug)
  local placeholder = "@@TYPEPLACEHOLDER@@"
  local new = content:gsub("(%.)(%s*)$", placeholder .. "%2", 1)
  if not new:find(placeholder, 1, true) then
    new = content .. string.format("\n<entity/PARSE_ERROR> a <entity/%s> .\n", type_slug)
  else
    new = new:gsub(placeholder, (replacement:gsub("%%", "%%%%")), 1)
  end
  f = io.open(ttl_path, "w"); f:write(new); f:close()
  return true
end

function M.add_type()
  local ttl = current_ttl_path()
  if not ttl then
    vim.notify("Not in an entity buffer", vim.log.levels.WARN); return
  end

  local cats = Sparql.list_category_slugs()
  local entries = {}
  for _, slug in ipairs(cats) do entries[#entries + 1] = { slug = slug, label = slug } end

  Picker.pick("KB: add type (Ctrl-n: create new from query)", entries,
              { allow_new = true }, function(res)
    if not res then return end
    if res.is_new then
      local s = Slug.normalize(res.label)
      ensure_category(s, res.label)
      append_type_edge(ttl, s)
      vim.cmd("checktime")
      vim.notify("Added new type: " .. s)
    else
      append_type_edge(ttl, res.slug)
      vim.cmd("checktime")
      vim.notify("Added type: " .. res.slug)
    end
  end)
end

return M
