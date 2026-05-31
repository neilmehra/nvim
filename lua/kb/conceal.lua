-- lua/kb/conceal.lua
-- Render `<entity/SLUG>` tokens as the entity label inline, via extmarks.
-- Requires `conceallevel=2`. With `concealcursor="nc"` (set by markview), the
-- raw token is revealed in insert mode so you can still edit it.

local M = {}

local NS = vim.api.nvim_create_namespace("kb_entity_refs")
local ENTITY_RE = "<entity/([a-z0-9-]+)>"

---@type table<string,string>|nil
local label_cache = nil

local function load_labels()
  local Sparql = require("kb.sparql")
  local entries = Sparql.list_entities()
  local map = {}
  for _, e in ipairs(entries) do map[e.slug] = e.label end
  return map
end

---Drop the cached labels. Called after `kb.sync()`.
function M.invalidate()
  label_cache = nil
end

---Decorate every `<entity/SLUG>` in the buffer with an inline label.
---@param bufnr integer|nil
function M.attach(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  if label_cache == nil then label_cache = load_labels() end

  vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for lnum, line in ipairs(lines) do
    local start = 1
    while true do
      local s, e, slug = line:find(ENTITY_RE, start)
      if not s then break end
      local label = label_cache[slug]
      if label then
        vim.api.nvim_buf_set_extmark(bufnr, NS, lnum - 1, s - 1, {
          end_col = e,
          conceal = "",
          virt_text = { { label, "@markup.link.label.markdown_inline" } },
          virt_text_pos = "inline",
        })
      end
      start = e + 1
    end
  end
end

---Reattach in every loaded buffer whose path looks like a kb entity md.
function M.refresh_all()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      local name = vim.api.nvim_buf_get_name(b)
      if name:match("/kb/entities/.+%.md$") then M.attach(b) end
    end
  end
end

return M
