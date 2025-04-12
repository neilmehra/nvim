return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "cpp",
      injector = { ---@type table<lc.lang, lc.inject>
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>\nusing namespace std;" },
          after = "int main() {}",
        },
      },
      image_support = true,
    },
  },
}
