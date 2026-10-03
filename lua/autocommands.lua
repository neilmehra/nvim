local is_mac = vim.fn.has "mac" == 1

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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
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
    -- macOS box has tectonic (homebrew), linux box has a full TeX Live
    local cmd
    if vim.fn.executable "tectonic" == 1 and (is_mac or vim.fn.executable "pdflatex" == 0) then
      cmd = { "tectonic", "--chatter", "minimal", filename }
    elseif vim.fn.executable "pdflatex" == 1 then
      cmd = { "pdflatex", "-interaction=nonstopmode", filename }
    else
      vim.notify("LaTeX: no tectonic or pdflatex on PATH", vim.log.levels.WARN)
      return
    end
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

