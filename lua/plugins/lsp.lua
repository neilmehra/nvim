return {
  {
    "neovim/nvim-lspconfig",
    commit = "649137cbc53a044bffde36294ce3160cb18f32c7",
    lazy = true,
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
      },
    },

    init = function ()
      local function lsp_keymaps(bufnr)
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
        keymap(bufnr, "n", "<leader>lI", "<cmd>Mason<cr>", opts)
        keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
        keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
        keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
      end

      local lspconfig = require "lspconfig"
      local on_attach = function(client, bufnr)
        if client.name == "sumneko_lua" then
          client.server_capabilities.documentFormattingProvider = false
        end

        if client.name == "pyright" then
          client.server_capabilities.documentFormattingProvider = false
        end

        if client.name == "tailwindcss" then
          	if client.server_capabilities.colorProvider then
              require("utils/documentcolors").buf_attach(bufnr)
              require("colorizer").attach_to_buffer(bufnr, { mode = "background", css = true, names = false, tailwind = false })
            end
        end


        lsp_keymaps(bufnr)
        require("illuminate").on_attach(client)
      end

      for _, server in pairs(require("utils").servers) do
        Opts = {
          on_attach = on_attach,
        }

        server = vim.split(server, "@")[1]

        local require_ok, conf_opts = pcall(require, "langs." .. server)
        if require_ok then
          Opts = vim.tbl_deep_extend("force", conf_opts, Opts)
        end

        lspconfig[server].setup(Opts)
      end
    end
  },
  {
    "williamboman/mason.nvim",
    commit = "4546dec8b56bc56bc1d81e717e4a935bc7cd6477",
    cmd = "Mason",
    event = "BufReadPre",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        commit = "93e58e100f37ef4fb0f897deeed20599dae9d128",
        lazy = true,
      },
    },
    opts = { ui = { icons = { package_installed = '', package_pending = '', package_uninstalled = '' } } },
    -- todo
    config = function (_, opts)
      require("mason").setup(opts)
      require("mason-lspconfig").setup {
        ensure_installed = require("utils").servers,
        automatic_installation = true,
      }
    end
  },
  {
    'jay-babu/mason-null-ls.nvim',
    commit = "ae0c5fa57468ac65617f1bf821ba0c3a1e251f0c",
    opts = {
      ensure_installed = { "stylua", "markdownlint", "cpplint", "clang_format" }
    }
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    commit = "60b4a7167c79c7d04d1ff48b55f2235bf58158a7",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        commit = "9a0d3bf7b832818c042aaf30f692b081ddd58bd9",
        lazy = true,
      },
    },
    opts = function()
      local nls = require('null-ls')
      return {
        sources = {
            nls.builtins.formatting.stylua,
            nls.builtins.formatting.markdownlint,
            -- nls.builtins.formatting.clang_format,
            nls.builtins.diagnostics.markdownlint,
            -- nls.builtins.diagnostics.cpplint,
        },
      }
    end,
  },

  -- fidget.nvim

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    -- NOTE: Keep branch option until further notice: https://shorta.link/wkrANvwU
    branch = 'legacy',
    opts = { window = { blend = 0 } },
  },

  -- typescript drop in replacement
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
      }
    },
  }
}
