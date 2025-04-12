return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
    },
    cmd = { "TSUpdateSync" },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "cmake",
          "cpp",
          "c",
          "diff",
          "gitignore",
          "git_rebase",
          "gitcommit",
          "lua",
          "make",
          "html",
          "json",
          "python",
          "sxhkdrc",
          "lua",
          "luadoc",
          "rust",
          "markdown",
          "markdown_inline",
          "latex",
          "vim",
          "vimdoc",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = {
          enable = true,
        },
      }
    end,
  },

}
