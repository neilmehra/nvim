return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "› ",
        border = "rounded",
        relative = "editor",
        prefer_width = 60,
        win_options = { winblend = 0, winhighlight = "Normal:Normal,FloatBorder:FloatBorder" },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        builtin = {
          border = "rounded",
          relative = "editor",
          win_options = { winblend = 0 },
        },
      },
    },
  },
}
