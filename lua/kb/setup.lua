-- lua/kb/setup.lua
-- Add  require("kb.setup")  to your init.lua (after require("autocommands"))

local kb = require("kb")

-- ── Autocmds ───────────────────────────────────────────

-- Inject TTL prefixes into new .ttl files under kb/kg/
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

-- ── Keymaps ────────────────────────────────────────────

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- create entities (md + ttl split)
map("n", "<leader>kn", function() kb.create("note") end,    "KB: new note")
map("n", "<leader>kc", function() kb.create("concept") end, "KB: new concept")
map("n", "<leader>ko", function() kb.create("moc") end,     "KB: new MOC")
map("n", "<leader>kr", function() kb.create("result") end,  "KB: new result")

-- sidecar navigation
map("n", "<leader>km", kb.open_sidecar,  "KB: open TTL sidecar (split)")
map("n", "<leader>kj", kb.jump_sidecar,  "KB: jump md <-> ttl")

-- quick capture
map("n", "<leader>ks", function() kb.capture_stub("concept") end, "KB: stub concept")
map("n", "<leader>kS", function() kb.capture_stub("result") end,  "KB: stub result")

-- telescope entity linking (telescope is lazy, require at call time)
map("n", "<leader>kl", function() require("kb.telescope").pick_entity("concept") end, "KB: link concept")
map("n", "<leader>kL", function() require("kb.telescope").pick_entity("note") end,    "KB: link note")
map("i", "<C-k>",      function() require("kb.telescope").pick_entity("concept") end, "KB: insert concept ref")

map("n", "<leader>kk", function()
  vim.cmd("cd " .. kb.root)
  vim.cmd("edit " .. kb.root .. "/inbox.md")
end, "KB: home (inbox)")

map("n", "<leader>kf", function()
  require("telescope.builtin").find_files({ cwd = kb.root })
end, "KB: find file")

map("n", "<leader>kg", function()
  require("telescope.builtin").live_grep({ cwd = kb.root })
end, "KB: grep")

map("n", "<leader>kq", function()
  local p = vim.fn.expand("%:p")
  local other
  if p:match("%.ttl$") then
    other = p:gsub("/kg/", "/"):gsub("%.ttl$", ".md")
  elseif p:match("%.md$") then
    for _, kind in ipairs({ "concepts", "mocs", "results", "notes" }) do
      if p:match("/" .. kind .. "/") then
        other = p:gsub("/" .. kind .. "/", "/kg/" .. kind .. "/"):gsub("%.md$", ".ttl")
        break
      end
    end
  end
  -- close both buffers
  local cur = vim.api.nvim_get_current_buf()
  local pair_buf
  if other then
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == other then
        pair_buf = b
        break
      end
    end
  end
  if pair_buf then vim.cmd("bdelete " .. pair_buf) end
  vim.cmd("bdelete " .. cur)
end, "KB: close pair")
