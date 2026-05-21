return {
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- skip the treesitter provider — its locals API broke after
      -- nvim-treesitter's main-branch rewrite (locals.lua: parent() nil error)
      require("illuminate").configure({
        providers = { "lsp", "regex" },
        delay = 120,
        filetypes_denylist = {
          "alpha", "NvimTree", "oil", "lazy", "mason",
          "TelescopePrompt", "TelescopeResults",
          "help", "qf", "checkhealth",
        },
        under_cursor = true,
        large_file_cutoff = 2000,
        large_file_overrides = { providers = { "lsp" } },
      })
    end,
  },
}
