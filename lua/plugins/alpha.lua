return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      local header = {
        type = "text",
        val = {},
        opts = { position = "center", hl = "AlphaAscii" },
      }

      local uv = vim.uv or vim.loop
      math.randomseed(uv.hrtime())
      local date = os.date("%m/%d/%y(%a)%X")

      local heading = {
        type = "text",
        val = ("  neilm %s "):format(date),
        opts = { position = "center", hl = "AlphaButtons" },
      }

      local function button(sc, txt, keybind)
        local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
        local opts = {
          position = "center",
          text = txt,
          shortcut = sc,
          cursor = 0,
          width = 44,
          align_shortcut = "right",
          hl_shortcut = "AlphaShortcuts",
          hl = "AlphaHeader",
        }
        if keybind then
          opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
        end
        return {
          type = "button",
          val = txt,
          on_press = function()
            local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
            vim.api.nvim_feedkeys(key, "normal", false)
          end,
          opts = opts,
        }
      end

      local buttons = {
        type = "group",
        val = {
          button("f", ">find file", "<cmd>Telescope find_files<cr>"),
          button("p", ">project", "<cmd>Telescope projects<cr>"),
          button("r", ">recent files", ":Telescope oldfiles <CR>"),
          button("s", ">scratchpad", "<cmd>e ~/neil/scratchpad<cr>"),
          button("t", ">live grep", "<cmd>Telescope live_grep<cr>"),
          button("c", ">config", "<cmd>e ~/dotfiles/nvim/init.lua<cr>"),
          button("q", ">quit", "<cmd>qa<cr>"),
        },
        opts = { spacing = 0 },
      }

      alpha.setup({
        layout = {
          { type = "padding", val = 1 },
          header,
          { type = "padding", val = 1 },
          heading,
          { type = "padding", val = 1 },
          buttons,
        },
        opts = { margin = 44 },
      })
    end,
  },
}
