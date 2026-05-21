return {
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown", "vimwiki" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        filetypes = { "markdown", "md", "vimwiki" },
        ignore_buftypes = { "nofile", "terminal" },
        modes = { "n", "no", "c" },
        hybrid_modes = { "i" },
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "nc"
          end,
        },
      },
    },
  },

  {
    "selimacerbas/markdown-preview.nvim",
    ft = { "markdown" },
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup {
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      }
    end,
  },
}
