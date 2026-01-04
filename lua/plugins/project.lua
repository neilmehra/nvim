-- TODO: https://github.com/DrKJeff16/project.nvim?tab=readme-ov-file#lazynvim
return {
  {
    "ahmedkhalf/project.nvim",
    event = "VimEnter", -- or {"BufReadPre","BufNewFile"}
    opts = {
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "Makefile", "package.json" },
      silent_chdir = true,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },
}

