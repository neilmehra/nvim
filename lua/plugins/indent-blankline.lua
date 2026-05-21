-- replaced indent-blankline with mini.indentscope — single subtle animated scope
-- line for the current block, less visual noise than full indent guides
return {
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      return {
        symbol = "│",
        draw = {
          delay = 80,
          animation = require("mini.indentscope").gen_animation.cubic({ duration = 60, unit = "total" }),
        },
        options = { try_as_border = true },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha", "oil", "Telescope", "TelescopePrompt", "TelescopeResults",
          "lazy", "mason", "help", "checkhealth", "neo-tree",
          "noice", "notify", "dashboard",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
