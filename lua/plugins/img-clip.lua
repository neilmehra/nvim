return {
  {
    "HakonHarnes/img-clip.nvim",
    cmd = "PasteImage",
    keys = {
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
    opts = {
      default = {
        -- assets/ next to the current file, linked relatively so any renderer resolves it
        dir_path = "assets",
        relative_to_current_file = true,
        file_name = "%Y%m%d-%H%M%S",
        prompt_for_file_name = false,
      },
    },
  },
}
