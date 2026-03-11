local keymap = vim.keymap.set
local opts = { silent = true }

-- Make <Space> do nothing in normal/visual so it acts as leader cleanly
keymap({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Window navigation
-- tmux plugin maps this to work w/ tmux panes asw
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffer without nuking layout
local function delete_buffer()
  local current = vim.api.nvim_get_current_buf()
  local alt = vim.fn.bufnr("#")
  if vim.api.nvim_buf_is_valid(alt) and vim.api.nvim_buf_is_loaded(alt) then
    vim.cmd("buffer " .. alt)
  else
    vim.cmd("bnext")
  end
  vim.cmd("bdelete " .. current)
end
keymap("n", "<S-q>", delete_buffer, opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Paste image from clipboard into current buffer dir (Markdown)
local function paste_image()
  local filename = os.date("image_%Y%m%d_%H%M%S") .. ".png"
  local dir = vim.fn.expand("%:p:h")
  local path = dir .. "/" .. filename
  vim.fn.system("xclip -selection clipboard -t image/png -o > " .. vim.fn.shellescape(path))
  vim.api.nvim_put({ "![](" .. filename .. ")" }, "", true, true)
end
keymap("n", "<leader>p", paste_image, { desc = "Paste clipboard image" })


-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)


