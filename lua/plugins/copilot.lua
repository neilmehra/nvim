return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-l>", -- idk do i have to change this for other thing to work?
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,      -- set false if you hate pop-in suggestions
        debounce = 75,
        keymap = {
          -- alt+l conflicts with tmux 
          -- accept = "<M-L>",       -- Alt+l to accept
          accept = "<M-CR>",
          accept_word = "<M-w>",
          accept_line = "<M-L>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        -- enable for your core languages
        cpp = true,
        c = true,
        python = true,
        lua = true,
        cmake = true,
        sh = true,
        bash = true,
        zsh = true,
        -- disable for noisy buffers
        markdown = false,
        help = false,
        gitcommit = true, -- optional: I like it on for commit message polish
      },
    },
  },

  -- Optional: expose Copilot as an nvim-cmp source.
  -- If you already rely heavily on LSP/snippets, you may want this.
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {},
    config = function(_, opts)
      require("copilot_cmp").setup(opts)
    end,
  },
}

