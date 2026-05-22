-- lua/kb/setup.lua
-- Add  require("kb.setup")  in init.lua after require("autocommands").

local kb = require("kb")

-- ── Autocmd: inject TTL prefixes in new files under kg/ ──────
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*/kb/kg/**/*.ttl",
  callback = function()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {
      "@base <https://kb.neil.me/> .",
      "@prefix kb:  <https://kb.neil.me/> .",
      "@prefix rel: <https://kb.neil.me/rel/> .",
      "@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .",
      "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .",
      "",
    })
    vim.api.nvim_win_set_cursor(0, { 7, 0 })
  end,
})

-- ── Keymaps ──────────────────────────────────────────────────
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<leader>K",  function() require("kb.create").create() end,        "KB: new entity")
map("n", "<leader>kt", function() require("kb.type").add_type() end,        "KB: add type")
map("n", "<leader>ke", function() require("kb.edge").add_edge() end,        "KB: add edge")
map("n", "<leader>kj", function() require("kb").jump_sidecar() end,         "KB: jump md ↔ ttl")
map("n", "<leader>kq", function() require("kb").close_pair() end,           "KB: close pair")
map("n", "<leader>kk", function() require("kb.viewer").open() end,          "KB: open viewer")
map("n", "<leader>kK", function() require("kb.viewer").open_focus() end,    "KB: open viewer (focus)")

-- Escape hatches
map("n", "<leader>kf", function()
  require("telescope.builtin").find_files({ cwd = kb.root })
end, "KB: find file")
map("n", "<leader>kg", function()
  require("telescope.builtin").live_grep({ cwd = kb.root })
end, "KB: grep")

-- Insert-mode entity ref picker
map("i", "<C-k>", function() require("kb.telescope").insert_entity_ref() end, "KB: insert entity ref")
