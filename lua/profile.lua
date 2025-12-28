local M = {}

-- Choose one of these toggles:
-- A) env var (recommended): NVIM_PROFILE=spine nvim
-- B) hostname contains "spine" (auto on that host)
local env = (vim.env.NVIM_PROFILE or ""):lower()
local hostname = (vim.loop.os_uname().nodename or ""):lower()

M.is_spine = (env == "spine") or hostname:find("spine", 1, true) ~= nil

return M

