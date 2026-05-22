-- lua/kb/edge.lua
-- Two-stage picker: relation, then target entity. Appends edge to current TTL.

local M = {}
local Sparql = require("kb.sparql")
local Picker = require("kb.telescope")

local COMMON_RELATIONS = {
  "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
  "https://kb.neil.me/rel/about",
  "https://kb.neil.me/rel/explains",
  "https://kb.neil.me/rel/requires",
  "https://kb.neil.me/rel/source",
  "https://kb.neil.me/rel/contradicts",
  "https://kb.neil.me/rel/includes",
  "https://kb.neil.me/rel/influences",
}

local function short(predicate)
  if predicate == "http://www.w3.org/1999/02/22-rdf-syntax-ns#type" then return "a" end
  return (predicate:gsub("^https://kb.neil.me/", ""))
end

local function current_ttl_path()
  local p = vim.fn.expand("%:p")
  if p:match("/kg/entities/.+%.ttl$") then return p end
  if p:match("/entities/.+%.md$") then
    return p:gsub("/entities/", "/kg/entities/"):gsub("%.md$", ".ttl")
  end
  return nil
end

local function append_edge(ttl_path, predicate, target_slug)
  local f = io.open(ttl_path, "r")
  if not f then return false end
  local content = f:read("*a"); f:close()
  local pred_token = short(predicate)
  if pred_token:match("^rel/") then pred_token = "rel:" .. pred_token:sub(5) end
  local snippet = string.format(";\n  %s <entity/%s> .", pred_token, target_slug)
  local placeholder = "@@EDGEPLACEHOLDER@@"
  local new = content:gsub("(%.)(%s*)$", placeholder .. "%2", 1)
  if not new:find(placeholder, 1, true) then
    new = content .. "\n# (parse failure, appended at end)\n" ..
      string.format("<entity/PARSE_ERROR> %s <entity/%s> .\n", pred_token, target_slug)
  else
    new = new:gsub(placeholder, (snippet:gsub("%%", "%%%%")), 1)
  end
  f = io.open(ttl_path, "w"); f:write(new); f:close()
  return true
end

function M.add_edge()
  local ttl = current_ttl_path()
  if not ttl then
    vim.notify("Not in an entity buffer", vim.log.levels.WARN); return
  end

  -- Stage 1: pick relation
  local rels_seen = Sparql.list_relations()
  local merged = {}
  local saw = {}
  for _, p in ipairs(rels_seen) do merged[#merged + 1] = p; saw[p] = true end
  for _, p in ipairs(COMMON_RELATIONS) do
    if not saw[p] then merged[#merged + 1] = p end
  end
  local rel_entries = {}
  for _, p in ipairs(merged) do
    rel_entries[#rel_entries + 1] = { slug = p, label = short(p) }
  end

  Picker.pick("KB: relation", rel_entries, {}, function(res)
    if not res or not res.slug then return end
    local predicate = res.slug

    local entities = Sparql.list_entities()
    Picker.pick("KB: target", entities, {}, function(res2)
      if not res2 or not res2.slug then return end
      append_edge(ttl, predicate, res2.slug)
      vim.cmd("checktime")
      vim.notify(string.format("Added edge: %s → %s", short(predicate), res2.slug))
    end)
  end)
end

return M
