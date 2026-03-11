-- lua/kb/telescope.lua
local M = {}

---@param kind "concept"|"note"|"moc"|"source"|"result"
function M.pick_entity(kind)
  kind = kind or "concept"
  local kb_root = require("kb").root

  local scan = {
    concept = "kg/concepts",
    note    = "kg/notes",
    moc     = "kg/mocs",
    source  = "kg/sources",
    result  = "kg/results",
  }
  local dir = kb_root .. "/" .. (scan[kind] or "kg/concepts")
  local files = vim.fn.globpath(dir, "*.ttl", false, true)
  local slugs = {}
  for _, f in ipairs(files) do
    table.insert(slugs, vim.fn.fnamemodify(f, ":t:r"))
  end

  if #slugs == 0 then
    vim.notify("No " .. kind .. " entities found", vim.log.levels.WARN)
    return
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "KB: " .. kind,
    finder = finders.new_table({ results = slugs }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local sel = action_state.get_selected_entry()
        if sel then
          vim.api.nvim_put({ "<" .. kind .. "/" .. sel[1] .. ">" }, "", true, true)
        end
      end)
      return true
    end,
  }):find()
end

return M
