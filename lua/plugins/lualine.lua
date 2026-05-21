-- ultra-minimal status: one dim line. mode lives in the cursor shape,
-- file lives in incline, position is the only number on the right.
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local diff = {
        "diff",
        colored = false,
        symbols = { added = " ", modified = " ", removed = " " },
        cond = function() return vim.fn.winwidth(0) > 80 end,
      }

      return {
        options = {
          theme = "pywal16-nvim",
          globalstatus = true,
          disabled_filetypes = { "alpha", "dashboard", "noice" },
          component_separators = "",
          section_separators = "",
        },
        sections = {
          lualine_a = {},                    -- no mode label (cursor shape does it)
          lualine_b = { { "branch", icon = "" }, "diagnostics" },
          lualine_c = {},                    -- filename owned by incline
          lualine_x = { diff },
          lualine_y = {},
          lualine_z = { { "location", padding = { left = 1, right = 1 } } },
        },
        inactive_sections = {},
      }
    end,
  },
}
