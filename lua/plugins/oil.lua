return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Oil (file explorer)" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view_options = { show_hidden = true },
      keymaps = {
        ["yp"] = {
          function() require("oil.actions").yank_entry.callback() end,
          mode = "n",
          desc = "Yank filepath",
        },
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
    end,
  },
}
