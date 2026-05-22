return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "bash", "cmake", "c", "cpp", "diff",
        "gitignore", "git_rebase", "gitcommit",
        "lua", "luadoc", "make", "html", "json",
        "python", "rust", "markdown", "markdown_inline",
        "latex", "vim", "vimdoc",
      }

      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then return end
          local ok, added = pcall(vim.treesitter.language.add, lang)
          if not (ok and added) then return end
          pcall(vim.treesitter.start, ev.buf, lang)
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
