-- lua/kb/viewer.lua
-- Launch the kg-serve viewer in the browser. Each call rebuilds the client
-- bundle and restarts the server so source edits are always picked up.

local M = {}
local kb = require("kb")

local SERVER_TS = kb.root .. "/kg-serve/src/server.ts"

local function server_running()
  local res = vim.system({ "curl", "-sS", "-o", "/dev/null", "-w", "%{http_code}",
                           kb.viewer_url .. "/api/health" }, { text = true }):wait()
  return res.stdout == "200"
end

local function stop_server()
  vim.system({ "pkill", "-f", SERVER_TS }):wait()
  for _ = 1, 20 do
    if not server_running() then return end
    vim.wait(50)
  end
end

local function build()
  local res = vim.system(
    { "bun", "run", "build" },
    { cwd = kb.root .. "/kg-serve", text = true }
  ):wait()
  if res.code ~= 0 then
    vim.notify("kg-serve build failed:\n" .. (res.stderr or ""), vim.log.levels.ERROR)
    return false
  end
  return true
end

local function start_server()
  vim.system({ "bun", "run", SERVER_TS }, { detach = true })
  for _ = 1, 30 do
    if server_running() then return true end
    vim.wait(100)
  end
  return false
end

---Rebuild the client bundle and (re)start the server. Returns true on success.
local function restart()
  stop_server()
  if not build() then return false end
  if not start_server() then
    vim.notify("kg-serve failed to start", vim.log.levels.ERROR)
    return false
  end
  return true
end

---Open the viewer at the default URL, rebuilding + restarting first.
function M.open()
  if not restart() then return end
  vim.system({ "xdg-open", kb.viewer_url .. "/" })
end

---Open viewer focused on the current entity, rebuilding + restarting first.
function M.open_focus()
  local p = vim.fn.expand("%:p")
  local slug = p:match("/entities/([^/]+)%.md$") or p:match("/kg/entities/([^/]+)%.ttl$")
  if not slug then
    vim.notify("Not in an entity buffer; opening default view", vim.log.levels.WARN)
    M.open(); return
  end
  if not restart() then return end
  vim.system({ "xdg-open", kb.viewer_url .. "/#focus=" .. slug })
end

return M
