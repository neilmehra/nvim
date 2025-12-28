-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffer without deleting window arrangement
local function delete_buffer()
  local current_buf = vim.api.nvim_get_current_buf()
  local alt_buf = vim.fn.bufnr "#"
  if vim.api.nvim_buf_is_valid(alt_buf) and vim.api.nvim_buf_is_loaded(alt_buf) then
    vim.cmd("buffer " .. alt_buf)
  else
    vim.cmd "bnext"
  end
  vim.cmd("bdelete " .. current_buf)
end

keymap("n", "<S-q>", delete_buffer, opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- Oil
keymap("n", "-", "<cmd>Oil<CR>", opts)

-- Notes
local function open_zathura_for_current_file()
  local full_path = vim.fn.expand "%:p"

  local base_source = "/home/neil/neil/notes/source"
  local base_compiled = "/home/neil/neil/notes/compiled"
  local source_abs = vim.fn.fnamemodify(base_source, ":p"):gsub("/+$", "")
  if not vim.startswith(full_path, source_abs .. "/") then
    vim.notify("Current file is not in source directory: " .. source_abs, vim.log.levels.ERROR)
    return
  end

  local relative_path = full_path:sub(#source_abs + 2)
  local relative_pdf_path = vim.fn.fnamemodify(relative_path, ":r") .. ".pdf"

  local compiled_abs = vim.fn.fnamemodify(base_compiled, ":p"):gsub("/+$", "")
  local output_pdf = compiled_abs .. "/" .. relative_pdf_path

  if vim.fn.filereadable(output_pdf) == 0 then
    if vim.fn.filereadable(output_pdf) == 0 then
      vim.notify("PDF not found: " .. output_pdf, vim.log.levels.ERROR)
      return
    end
  end

  vim.fn.jobstart({ "zathura", output_pdf }, { detach = true })
end

keymap("n", "<leader>z", open_zathura_for_current_file, opts)


local function paste_image()
  local filename = os.date("image_%Y%m%d_%H%M%S") .. ".png"
  local buffer_dir = vim.fn.expand("%:p:h")

  local filepath = buffer_dir .. "/" .. filename
  vim.fn.system("xclip -selection clipboard -t image/png -o > " .. vim.fn.shellescape(filepath))

  local markdown_str = "![](" .. filename .. ")"
  vim.api.nvim_put({ markdown_str }, "", true, true)
end

keymap("n", "<leader>p", paste_image, opts);



local function sidecar_path(note_path)
  local p = note_path
  p = p:gsub("/notes/", "/kg/notes/")
  p = p:gsub("%.md$", ".ttl")
  return p
end

local function ensure_file(path, lines)
  local f = io.open(path, "r")
  if f then f:close(); return end
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  local wf = io.open(path, "w")
  for _, l in ipairs(lines) do wf:write(l .. "\n") end
  wf:close()
end

vim.keymap.set("n", "<leader>km", function()
  local note = vim.fn.expand("%:p")
  if not note:match("/notes/") or not note:match("%.md$") then
    print("Not a notes/*.md file")
    return
  end
  local side = sidecar_path(note)

  ensure_file(side, {
'@prefix kb:  <https://kb.neil.me/> .',
'@prefix rel: <https://kb.neil.me/rel/> .',
'@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .',
'@prefix rdfs:<http://www.w3.org/2000/01/rdf-schema#> .',
'',
'kb:note/aluffi-0.1-reading',
'  a kb:Note ;',
'  rel:file "notes/math/aluffi/ch0/0.1-reading.md" ;',
'  rel:tag kb:status/draft ;',
'  rel:tag kb:subject/abstract-algebra ;',
'  rel:inSource kb:source/aluffi-algebra ;',
'  rel:inSection kb:section/aluffi-0.1 ;',
'  rel:about kb:concept/group ;',
'  rel:about kb:concept/homomorphism .'
  })

  vim.cmd("vsplit " .. vim.fn.fnameescape(side))
end, { desc = "Open KG sidecar for current note" })
