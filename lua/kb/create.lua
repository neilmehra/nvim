local M = {}
local kb = require("kb")
local Slug = require("kb.slug")

local function ttl_prelude()
  return {
    "@base <https://kb.neil.me/> .",
    "@prefix kb:  <https://kb.neil.me/> .",
    "@prefix rel: <https://kb.neil.me/rel/> .",
    "@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .",
    "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .",
    "",
  }
end

local function today() return os.date("%Y-%m-%d") end

local function ensure_dirs()
  vim.fn.mkdir(kb.root .. "/entities", "p")
  vim.fn.mkdir(kb.root .. "/kg/entities", "p")
end

---@param cat_slug string
---@param label string  human-readable label for the category
local function ensure_category(cat_slug, label)
  local ttl_path = kb.root .. "/kg/entities/" .. cat_slug .. ".ttl"
  if vim.fn.filereadable(ttl_path) == 1 then return end
  local lines = ttl_prelude()
  lines[#lines + 1] =
    string.format('<entity/%s> rdfs:label "%s" ;', cat_slug, label:gsub('"', '\\"'))
  lines[#lines + 1] =
    string.format('  rel:created "%s"^^xsd:date .', today())
  lines[#lines + 1] = ""
  local f = io.open(ttl_path, "w")
  f:write(table.concat(lines, "\n"))
  f:close()
end

---@param raw_types string  comma-separated raw user input, possibly empty
---@return table[]  list of {slug, label}
local function parse_types(raw_types)
  local out = {}
  if not raw_types or raw_types == "" then return out end
  for piece in raw_types:gmatch("[^,]+") do
    local label = piece:gsub("^%s+", ""):gsub("%s+$", "")
    if label ~= "" then
      out[#out + 1] = { slug = Slug.normalize(label), label = label }
    end
  end
  return out
end

local function write_entity(slug, name, types)
  local md_path  = kb.root .. "/entities/"     .. slug .. ".md"
  local ttl_path = kb.root .. "/kg/entities/"  .. slug .. ".ttl"

  -- markdown
  local fmd = io.open(md_path, "w")
  fmd:write("# " .. name .. "\n\n")
  fmd:close()

  -- ttl
  local lines = ttl_prelude()
  lines[#lines + 1] = string.format('<entity/%s> rdfs:label "%s" ;', slug, name:gsub('"', '\\"'))
  lines[#lines + 1] = string.format('  rel:file "entities/%s.md" ;', slug)
  lines[#lines + 1] = string.format('  rel:created "%s"^^xsd:date', today())
  if #types > 0 then
    local refs = {}
    for _, t in ipairs(types) do refs[#refs + 1] = "<entity/" .. t.slug .. ">" end
    lines[#lines]   = lines[#lines] .. " ;"
    lines[#lines+1] = "  a " .. table.concat(refs, ", ") .. " ."
  else
    lines[#lines]   = lines[#lines] .. " ."
  end
  lines[#lines + 1] = ""
  local fttl = io.open(ttl_path, "w")
  fttl:write(table.concat(lines, "\n"))
  fttl:close()
end

---Pick a slug that isn't already taken. Collisions are astronomically
---unlikely at 32^8, but a stat is cheaper than a silent overwrite.
local function fresh_slug()
  for _ = 1, 10 do
    local slug = Slug.new()
    local md, ttl = kb.paths(slug)
    if vim.fn.filereadable(md) == 0 and vim.fn.filereadable(ttl) == 0 then
      return slug
    end
  end
  return nil
end

---Create the md + ttl pair for `name`, after prompting for types.
---@param name string|nil  human-readable label; nil/blank aborts
function M.create_with_name(name)
  if not name then return end
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  if name == "" then return end

  vim.ui.input({ prompt = "types (comma-separated, optional): " }, function(raw_types)
    if raw_types == nil then return end  -- cancelled

    local slug = fresh_slug()
    if not slug then
      vim.notify("KB: could not allocate a free slug", vim.log.levels.ERROR)
      return
    end

    local types = parse_types(raw_types)
    ensure_dirs()
    for _, t in ipairs(types) do ensure_category(t.slug, t.label) end
    write_entity(slug, name, types)
    kb.sync()

    kb.open_entity(slug)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
  end)
end

function M.create()
  vim.ui.input({ prompt = "name: " }, function(name)
    M.create_with_name(name)
  end)
end

return M
