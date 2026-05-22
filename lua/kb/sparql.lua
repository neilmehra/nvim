-- lua/kb/sparql.lua
-- Small synchronous SPARQL client for oxigraph. Uses curl via vim.system.

local M = {}

local ENDPOINT = "http://127.0.0.1:7878"

---Run a SELECT query. Returns rows as a list of tables keyed by variable name.
---@param query string
---@return table[]
function M.select(query)
  local res = vim.system({
    "curl", "-sS", "-X", "POST",
    "-H", "Content-Type: application/sparql-query",
    "-H", "Accept: application/sparql-results+json",
    "--data-binary", query,
    ENDPOINT .. "/query",
  }, { text = true }):wait()
  if res.code ~= 0 then
    vim.notify("SPARQL error: " .. (res.stderr or ""), vim.log.levels.ERROR)
    return {}
  end
  local ok, json = pcall(vim.json.decode, res.stdout)
  if not ok or not json or not json.results then return {} end
  local rows = {}
  for _, b in ipairs(json.results.bindings) do
    local row = {}
    for k, v in pairs(b) do row[k] = v.value end
    rows[#rows + 1] = row
  end
  return rows
end

---@return string[]  slugs of nodes that appear as objects of rdf:type
function M.list_category_slugs()
  local rows = M.select([[
    SELECT DISTINCT ?t WHERE { ?s a ?t }
  ]])
  local slugs = {}
  for _, r in ipairs(rows) do
    local slug = r.t:match("entity/(.+)$")
    if slug then slugs[#slugs + 1] = slug end
  end
  table.sort(slugs)
  return slugs
end

---@return table[]  {slug, label} for all entities
function M.list_entities()
  local rows = M.select([[
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    SELECT ?s ?label WHERE {
      ?s rdfs:label ?label .
    } ORDER BY ?label
  ]])
  local out = {}
  for _, r in ipairs(rows) do
    local slug = r.s:match("entity/(.+)$")
    if slug then out[#out + 1] = { slug = slug, label = r.label } end
  end
  return out
end

---@return string[]  distinct predicate URIs (relations) appearing in the store
function M.list_relations()
  local rows = M.select([[
    SELECT DISTINCT ?p WHERE { ?s ?p ?o }
  ]])
  local preds = {}
  for _, r in ipairs(rows) do preds[#preds + 1] = r.p end
  table.sort(preds)
  return preds
end

return M
