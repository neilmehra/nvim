return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = {
        enabled = false,
      },
    },
  },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "inline",
          floating_windows = false, -- if true, images will be rendered in floating markdown windows
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
    },
  },
}
