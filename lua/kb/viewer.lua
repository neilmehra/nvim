-- lua/kb/viewer.lua
-- Launch the kg-serve viewer in the browser. Each call rebuilds the client
-- bundle and restarts the server so source edits are always picked up.

local M = {}
local kb = require("kb")

local SERVER_TS = kb.root .. "/kg-serve/src/server.ts"

---Open a URL in the system browser. `vim.ui.open` picks the right launcher
---per platform (`open` on macOS, `xdg-open` on Linux, `start` on Windows).
local function open_url(url)
  local _, err = vim.ui.open(url)
  if err then vim.notify("could not open browser: " .. err, vim.log.levels.ERROR) end
end

---Fail loudly and legibly when the toolchain is missing, rather than letting
---`vim.system` raise a bare ENOENT from deep inside the restart path.
local function have_deps()
  if vim.fn.executable("bun") == 0 then
    vim.notify("kg-serve needs `bun` on PATH (https://bun.sh)", vim.log.levels.ERROR)
    return false
  end
  return true
end

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
  if not have_deps() then return false end
  stop_server()
  if not build() then return false end
  if not start_server() then
    vim.notify("kg-serve failed to start", vim.log.levels.ERROR)
    return false
  end
  -- The viewer starts fine without oxigraph, but every graph query comes back
  -- empty, which reads as "the viewer is broken". Say which half is down.
  local res = vim.system({ "curl", "-sS", "-o", "/dev/null", "-w", "%{http_code}",
                           "--max-time", "2", kb.endpoint .. "/query" }, { text = true }):wait()
  if res.stdout == "000" then
    vim.notify("oxigraph unreachable at " .. kb.endpoint .. "; graph will be empty",
      vim.log.levels.WARN)
  end
  return true
end

---Open the viewer at the default URL, rebuilding + restarting first.
function M.open()
  if not restart() then return end
  open_url(kb.viewer_url .. "/")
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
  open_url(kb.viewer_url .. "/#focus=" .. slug)
end

return M
