vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    -- image.nvim should be fixed now
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Automatically close tab/vim when nvim-tree is the last window in the tab
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

local function convert_to_pdf()
  local full_path = vim.fn.expand "%:p" -- e.g., /home/neil/neil/notes/source/subdir/file_name.md

  local base_source = "/home/neil/neil/notes/source"
  local base_compiled = "/home/neil/neil/notes/compiled"

  local source_abs = vim.fn.fnamemodify(base_source, ":p"):gsub("/+$", "")
  local compiled_abs = vim.fn.fnamemodify(base_compiled, ":p"):gsub("/+$", "")

  if not vim.fn.isdirectory(source_abs) then
    vim.notify("Source directory does not exist: " .. source_abs, vim.log.levels.ERROR)
    return
  end

  if not vim.fn.isdirectory(compiled_abs) then
    vim.notify("Compiled directory does not exist. Attempting to create: " .. compiled_abs, vim.log.levels.INFO)
    local mkdir_result = vim.fn.mkdir(compiled_abs, "p")
    if mkdir_result == 0 then
      vim.notify("Failed to create compiled directory: " .. compiled_abs, vim.log.levels.ERROR)
      return
    else
      vim.notify("Successfully created compiled directory: " .. compiled_abs, vim.log.levels.INFO)
    end
  end

  local source_with_slash = source_abs .. "/"
  if not vim.startswith(full_path, source_with_slash) then
    vim.notify("File is not inside source directory: " .. source_abs, vim.log.levels.ERROR)
    return
  end

  local relative_path = full_path:sub(#source_abs + 2) -- +2 to remove the '/' separator

  local relative_pdf_path = vim.fn.fnamemodify(relative_path, ":r") .. ".pdf"

  local output_pdf = compiled_abs .. "/" .. relative_pdf_path

  local output_dir = vim.fn.fnamemodify(output_pdf, ":h")

  local mkdir_result = vim.fn.mkdir(output_dir, "p")
  if mkdir_result == 0 and not vim.fn.isdirectory(output_dir) then
    vim.notify("Failed to create directory: " .. output_dir, vim.log.levels.ERROR)
    return
  end

  local file_dir = vim.fn.fnamemodify(full_path, ":h")

  local file_name = vim.fn.fnamemodify(full_path, ":t")

  local cmd = string.format(
    'cd "%s" && pandoc -f markdown-implicit_figures -s "%s" -o "%s" >/dev/null 2>&1',
    file_dir,
    file_name,
    output_pdf
  )

  local dir = vim.fn.fnamemodify(full_path, ":h")
  -- vim.fn.system(cmd)

  vim.fn.jobstart(cmd, {
    cwd = dir,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        if exit_code == 0 then
          vim.notify("Pandoc conversion succeeded!", vim.log.levels.INFO)
        else
          vim.notify("Pandoc conversion failed!", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "/home/neil/neil/notes/source/**/*.md",
  callback = function()
    convert_to_pdf()
  end,
})

vim.api.nvim_create_augroup("LatexAutocompile", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = "LatexAutocompile",
  pattern = "*.tex",
  callback = function()
    local file = vim.fn.expand "%:p"
    local dir = vim.fn.fnamemodify(file, ":h")
    local filename = vim.fn.fnamemodify(file, ":t")
    local cmd = { "pdflatex", "-interaction=nonstopmode", filename }
    vim.fn.jobstart(cmd, {
      cwd = dir,
      on_exit = function(_, exit_code, _)
        vim.schedule(function()
          if exit_code == 0 then
            vim.notify("LaTeX: Compilation succeeded!", vim.log.levels.INFO)
          else
            vim.notify("LaTeX: Compilation failed!", vim.log.levels.ERROR)
          end
        end)
      end,
    })
  end,
})
