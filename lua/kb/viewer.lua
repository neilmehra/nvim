-- lua/kb/viewer.lua
-- Launch the kg-serve viewer in the browser. Starts the server detached if needed.

local M = {}
local kb = require("kb")

local function server_running()
  local res = vim.system({ "curl", "-sS", "-o", "/dev/null", "-w", "%{http_code}",
                           kb.viewer_url .. "/api/health" }, { text = true }):wait()
  return res.stdout == "200"
end

local function start_server()
  local cmd = { "bun", "run", kb.root .. "/kg-serve/src/server.ts" }
  vim.system(cmd, { detach = true })
  for _ = 1, 30 do
    if server_running() then return true end
    vim.wait(100)
  end
  return false
end

---Open the viewer at the default URL.
function M.open()
  if not server_running() then
    vim.notify("Starting kg-serve…", vim.log.levels.INFO)
    if not start_server() then
      vim.notify("kg-serve failed to start", vim.log.levels.ERROR); return
    end
  end
  vim.system({ "xdg-open", kb.viewer_url .. "/" })
end

---Open viewer focused on the current entity.
function M.open_focus()
  local p = vim.fn.expand("%:p")
  local slug = p:match("/entities/([^/]+)%.md$") or p:match("/kg/entities/([^/]+)%.ttl$")
  if not slug then
    vim.notify("Not in an entity buffer; opening default view", vim.log.levels.WARN)
    M.open(); return
  end
  if not server_running() then
    if not start_server() then
      vim.notify("kg-serve failed to start", vim.log.levels.ERROR); return
    end
  end
  vim.system({ "xdg-open", kb.viewer_url .. "/#focus=" .. slug })
end

return M
