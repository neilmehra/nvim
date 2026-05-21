return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "cmake",
          "c",
          "cpp",
          "diff",
          "gitignore",
          "git_rebase",
          "gitcommit",
          "lua",
          "luadoc",
          "make",
          "html",
          "json",
          "python",
          "rust",
          "markdown",
          "markdown_inline",
          "latex",
          "vim",
          "vimdoc",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      })
    end,
  },
}
