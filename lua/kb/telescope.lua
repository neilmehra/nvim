-- lua/kb/telescope.lua
-- Generic entity picker. The callback receives either a selection table or nil.

local M = {}

---Show a picker over entries. Callback receives:
---  nil                                  if user cancelled (Esc)
---  { slug = "...", label = "..." }      on selection
---  { is_new = true, label = <query> }   on <C-n> when opts.allow_new is true
---@param prompt string
---@param entries table[]  list of {slug, label}
---@param opts {allow_new: boolean}|nil
---@param cb fun(result: table|nil)
function M.pick(prompt, entries, opts, cb)
  opts = opts or {}
  if entries == nil then entries = {} end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = prompt,
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e)
        return {
          value = e,
          display = e.label or e.slug or "(unknown)",
          ordinal = (e.label or "") .. " " .. (e.slug or ""),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local sel = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if sel and sel.value then
          cb({ slug = sel.value.slug, label = sel.value.label })
        else
          cb(nil)
        end
      end)
      if opts.allow_new then
        map({ "i", "n" }, "<C-n>", function()
          local query = action_state.get_current_line()
          actions.close(prompt_bufnr)
          if query and query ~= "" then
            cb({ label = query, is_new = true })
          else
            cb(nil)
          end
        end)
      end
      return true
    end,
  }):find()
end

---Insert `<entity/slug>` at cursor (for `<C-k>` insert-mode binding).
function M.insert_entity_ref()
  local Sparql = require("kb.sparql")
  M.pick("KB: insert entity ref", Sparql.list_entities(), {}, function(res)
    if res and res.slug then
      vim.api.nvim_put({ "<entity/" .. res.slug .. ">" }, "", true, true)
    end
  end)
end

return M
