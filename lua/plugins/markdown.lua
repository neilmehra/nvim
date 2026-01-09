return {
  { "jbyuki/nabla.nvim" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "vimwiki" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      latex = { enabled = false },
      win_options = { conceallevel = { rendered = 2 } },
      on = {
        render = function()
          require("nabla").enable_virt { autogen = true }
        end,
        clear = function()
          require("nabla").disable_virt()
        end,
      },
    },
  },
  {
    "3rd/image.nvim",
    ft = { "markdown", "vimwiki" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "inline",
          floating_windows = false,
          filetypes = { "markdown", "vimwiki" },
        },
      },
      max_height_window_percentage = 50,
    },
  },
}
