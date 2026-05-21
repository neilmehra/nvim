return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        progress = { enabled = true },
        hover = { enabled = true, silent = true },
        signature = { enabled = true },
      },
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline   = { icon = "" },
          search_down = { icon = " " },
          search_up   = { icon = " " },
          filter      = { icon = " " },
          lua         = { icon = " " },
          help        = { icon = "󰋖 " },
        },
      },
      messages = {
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
      },
      popupmenu = { backend = "nui" },
      presets = {
        bottom_search = false,
        command_palette = true,    -- cmdline + popupmenu floating in middle
        long_message_to_split = true,
        lsp_doc_border = true,
        inc_rename = false,
      },
      routes = {
        -- silence "written" / "lines" messages
        { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 2500,
      max_height = function() return math.floor(vim.o.lines * 0.5) end,
      max_width  = function() return math.floor(vim.o.columns * 0.4) end,
      stages = "static",
      render = "compact",
      background_colour = "#080510",
      fps = 30,
      top_down = false,
    },
  },
}
