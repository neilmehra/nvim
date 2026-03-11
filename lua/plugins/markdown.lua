return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "vimwiki" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      latex = { enabled = false },
      win_options = { conceallevel = { rendered = 2 } },
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
