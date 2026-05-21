return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = {
          margin = { vertical = 0, horizontal = 1 },
          padding = 1,
          placement = { vertical = "top", horizontal = "right" },
          zindex = 30,
        },
        hide = { cursorline = true, focused_win = false },
        render = function(props)
          local bufname = vim.api.nvim_buf_get_name(props.buf)
          if bufname == "" then
            return { { "[No Name]", group = "Comment" } }
          end

          -- show parent_dir / filename for context, dim parent
          local filename = vim.fn.fnamemodify(bufname, ":t")
          local parent   = vim.fn.fnamemodify(bufname, ":h:t")
          local icon, icon_color = devicons.get_icon_color(filename, nil, { default = true })
          local modified = vim.bo[props.buf].modified
          local mod_indicator = modified and { "● ", group = "DiagnosticWarn" } or { "" }

          return {
            mod_indicator,
            { icon .. " ", guifg = icon_color },
            { parent .. "/", group = "Comment" },
            { filename, gui = modified and "bold,italic" or "bold" },
          }
        end,
      })
    end,
  },
}
