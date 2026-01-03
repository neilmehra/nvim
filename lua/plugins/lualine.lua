return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "jesseleite/nvim-noirbuddy" },
    opts = function()
      local function hide_in_width()
        return vim.fn.winwidth(0) > 80
      end

      local diff = {
        "diff",
        colored = false,
        symbols = { added = " ", modified = " ", removed = " " },
        cond = hide_in_width,
      }

      local noirbuddy_lualine = require("noirbuddy.plugins.lualine")

      return {
        options = {
          theme = noirbuddy_lualine.theme,
          globalstatus = true,
          disabled_filetypes = { "alpha", "dashboard" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diagnostics" },
          lualine_c = { "buffers" },
          lualine_d = { "filename" },
          lualine_x = { diff },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {},
      }
    end,
  },
}
