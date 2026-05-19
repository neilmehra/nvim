return {
  {
    "DrKJeff16/project.nvim",
    event = "VimEnter",
    opts = {
      -- lsp detection is enabled by default; patterns covers the rest
      patterns = { ".git", "Makefile", "package.json" },
      silent_chdir = true,
    },
    config = function(_, opts)
      require("project").setup(opts)
    end,
  },
}
