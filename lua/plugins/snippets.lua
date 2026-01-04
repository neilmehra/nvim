return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
      local types = require "luasnip.util.types"
      return {
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
          [types.choiceNode] = {
            active = { virt_text = { { "choice", "Comment" } } },
          },
        },
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
        ft_func = function()
          return vim.split(vim.bo.filetype, ".", true)
        end,
      }
    end,
    config = function(_, opts)
      local ls = require "luasnip"
      ls.config.set_config(opts)

      -- Friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- custom snippets
      require("luasnip.loaders.from_lua").load {
        paths = vim.fn.stdpath "config" .. "/lua/snippets",
      }

      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "LuaSnip next choice" })

      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = "LuaSnip prev choice" })

      -- for turtle files
      ls.filetype_extend("turtle", { "ttl" })
    end,
  },
}
