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

vim.api.nvim_create_autocmd("BufWritePost", {
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
