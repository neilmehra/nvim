-- lua/kb/init.lua
local M = {}

M.root = vim.fn.expand("~/kb")
M.endpoint = "http://127.0.0.1:7878"
M.viewer_url = "http://127.0.0.1:7879"

---@param slug string
---@return string md path
---@return string ttl path
function M.paths(slug)
  return M.root .. "/entities/" .. slug .. ".md",
         M.root .. "/kg/entities/" .. slug .. ".ttl"
end

---Open the md and ttl for a given slug as a vsplit (md left, ttl right).
---@param slug string
function M.open_entity(slug)
  local md, ttl = M.paths(slug)
  if vim.fn.filereadable(md) == 0 and vim.fn.filereadable(ttl) == 0 then
    vim.notify("No entity '" .. slug .. "'", vim.log.levels.WARN)
    return
  end
  vim.cmd("edit " .. vim.fn.fnameescape(md))
  vim.cmd("vsplit " .. vim.fn.fnameescape(ttl))
end

---Jump between the .md and its .ttl sidecar (replaces current buffer).
function M.jump_sidecar()
  local p = vim.fn.expand("%:p")
  local target
  if p:match("/kg/entities/") and p:match("%.ttl$") then
    target = p:gsub("/kg/entities/", "/entities/"):gsub("%.ttl$", ".md")
  elseif p:match("/entities/") and p:match("%.md$") then
    target = p:gsub("/entities/", "/kg/entities/"):gsub("%.md$", ".ttl")
  end
  if target and vim.fn.filereadable(target) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(target))
  else
    vim.notify("No sidecar found", vim.log.levels.WARN)
  end
end

---Close both md and ttl buffers of the current entity together.
function M.close_pair()
  local p = vim.fn.expand("%:p")
  local other
  if p:match("/kg/entities/.+%.ttl$") then
    other = p:gsub("/kg/entities/", "/entities/"):gsub("%.ttl$", ".md")
  elseif p:match("/entities/.+%.md$") then
    other = p:gsub("/entities/", "/kg/entities/"):gsub("%.md$", ".ttl")
  end
  local cur = vim.api.nvim_get_current_buf()
  local pair_buf
  if other then
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == other then
        pair_buf = b; break
      end
    end
  end
  if pair_buf then vim.cmd("bdelete " .. pair_buf) end
  vim.cmd("bdelete " .. cur)
end

return M
