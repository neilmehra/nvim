return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 92,
        height = 1,
        options = {
          number = false,
          relativenumber = false,
          cursorline = false,
          signcolumn = "no",
        },
      },
      plugins = {
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        twilight = { enabled = true },
        kitty = { enabled = false, font = "+2" },
      },
    },
  },

  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {
      dimming = { alpha = 0.30, inactive = false },
      context = 12,
      treesitter = true,
      expand = { "function", "method", "table", "if_statement" },
    },
  },
}
