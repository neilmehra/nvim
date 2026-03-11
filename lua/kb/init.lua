-- lua/kb/init.lua
local M = {}

M.root = vim.fn.expand("~/kb")

function M.slug_to_label(slug)
  return (slug:gsub("%-", " "):gsub("^%l", string.upper))
end

local dirs = {
  note    = { md = "notes",    ttl = "kg/notes" },
  concept = { md = "concepts", ttl = "kg/concepts" },
  moc     = { md = "mocs",    ttl = "kg/mocs" },
  result  = { md = "results",  ttl = "kg/results" },
}

---@param kind "note"|"concept"|"moc"
function M.create(kind)
  local slug = vim.fn.input(kind .. " slug: ")
  if slug == "" then return end

  local d = dirs[kind]
  local md_path  = M.root .. "/" .. d.md  .. "/" .. slug .. ".md"
  local ttl_path = M.root .. "/" .. d.ttl .. "/" .. slug .. ".ttl"

  vim.fn.mkdir(vim.fn.fnamemodify(md_path, ":h"), "p")
  vim.fn.mkdir(vim.fn.fnamemodify(ttl_path, ":h"), "p")

  for _, p in ipairs({ md_path, ttl_path }) do
    if vim.fn.filereadable(p) == 0 then
      local f = io.open(p, "w"); f:close()
    end
  end

  vim.cmd("edit " .. vim.fn.fnameescape(md_path))
  vim.cmd("vsplit " .. vim.fn.fnameescape(ttl_path))

  vim.schedule(function()
    if vim.api.nvim_buf_line_count(0) == 1
      and vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == "" then
      local snips = require("luasnip").get_snippets("turtle") or {}
      local target = "kb" .. kind
      for _, snip in ipairs(snips) do
        if snip.trigger == target then
          require("luasnip").snip_expand(snip)
          return
        end
      end
    end
  end)
end

function M.open_sidecar()
  local p = vim.fn.expand("%:p")
  if not p:match("%.md$") then
    vim.notify("Not an .md file", vim.log.levels.WARN)
    return
  end
  -- Detect which top-level dir: concepts/, mocs/, results/, notes/
  local side
  for _, kind in ipairs({ "concepts", "mocs", "results", "notes" }) do
    local pattern = "/" .. kind .. "/"
    if p:match(pattern) then
      side = p:gsub(pattern, "/kg/" .. kind .. "/"):gsub("%.md$", ".ttl")
      break
    end
  end
  if not side then
    vim.notify("Not under a KB directory", vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(side) == 0 then
    vim.fn.mkdir(vim.fn.fnamemodify(side, ":h"), "p")
    local f = io.open(side, "w"); f:close()
  end
  vim.cmd("vsplit " .. vim.fn.fnameescape(side))
end

function M.jump_sidecar()
  local p = vim.fn.expand("%:p")
  local target
  if p:match("%.ttl$") then
    -- kg/concepts/foo.ttl → concepts/foo.md
    target = p:gsub("/kg/", "/"):gsub("%.ttl$", ".md")
  elseif p:match("%.md$") then
    -- concepts/foo.md → kg/concepts/foo.ttl
    for _, kind in ipairs({ "concepts", "mocs", "results", "notes" }) do
      local pattern = "/" .. kind .. "/"
      if p:match(pattern) then
        target = p:gsub(pattern, "/kg/" .. kind .. "/"):gsub("%.md$", ".ttl")
        break
      end
    end
  end
  if target and vim.fn.filereadable(target) == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(target))
  else
    vim.notify("No sidecar found", vim.log.levels.WARN)
  end
end

function M.capture_stub(kind)
  kind = kind or "concept"
  local slug = vim.fn.input("Stub " .. kind .. ": ")
  if slug == "" then return end
  local oneliner = vim.fn.input("one-liner: ")
  local inbox = M.root .. "/inbox.md"
  local f = io.open(inbox, "a")
  f:write(string.format("- [ ] `<%s/%s>` — %s\n", kind, slug, oneliner))
  f:close()
  vim.notify("Captured: " .. slug, vim.log.levels.INFO)
end

return M
