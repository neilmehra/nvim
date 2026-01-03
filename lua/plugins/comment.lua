return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>/",
        function() require("Comment.api").toggle.linewise.current() end,
        desc = "Toggle comment (line)",
      },
      {
        "<leader>/",
        function() require("Comment.api").toggle.linewise(vim.fn.visualmode()) end,
        mode = "x",
        desc = "Toggle comment (selection)",
      },
    },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = function()
      local ok, integ = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if ok then
        return { pre_hook = integ.create_pre_hook() }
      end
      return {}
    end,
  },
}
