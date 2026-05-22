-- lua/kb/slug.lua
-- Crockford base32 slug generator. 8 chars = 32^8 keyspace.

local M = {}

local ALPHABET = "0123456789abcdefghjkmnpqrstvwxyz"  -- Crockford, lowercase, no i/l/o/u
local LENGTH = 8

math.randomseed(os.time() + (vim.loop.hrtime() % 1000000))

function M.new()
  local out = {}
  for _ = 1, LENGTH do
    local n = math.random(1, #ALPHABET)
    out[#out + 1] = ALPHABET:sub(n, n)
  end
  return table.concat(out)
end

---@param s string
---@return string
function M.normalize(s)
  -- For category-node slugs: lowercase, spaces/underscores → hyphens, strip non [a-z0-9-]
  s = s:lower()
  s = s:gsub("[%s_]+", "-")
  s = s:gsub("[^a-z0-9%-]", "")
  s = s:gsub("%-+", "-")
  s = s:gsub("^%-", ""):gsub("%-$", "")
  return s
end

return M
