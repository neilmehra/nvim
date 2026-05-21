return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    keys = {
      { "<leader>/", "<Plug>(comment_toggle_linewise_current)", mode = "n", desc = "Toggle comment (line)" },
      { "<leader>/", "<Plug>(comment_toggle_linewise_visual)",  mode = "x", desc = "Toggle comment (selection)" },
    },
    opts = function()
      vim.g.skip_ts_context_commentstring_module = true
      require("ts_context_commentstring").setup({ enable_autocmd = false })
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
}
