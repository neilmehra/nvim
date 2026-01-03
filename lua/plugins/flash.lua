return {
  {
    "folke/flash.nvim",
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({ jump = { autojump = true } })
        end,
        desc = "Flash",
      },
    },
  },
}
