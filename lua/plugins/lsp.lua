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
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
end

vim.g.rustaceanvim = {
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      lsp_keymaps(bufnr)
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
      },
    },

    init = function()
      local lspconfig = require "lspconfig"

      local on_attach = function(client, bufnr)
        lsp_keymaps(bufnr)
        -- require("illuminate").on_attach(client)
      end

      lspconfig["clangd"].setup {
        on_attach = on_attach,
      }

      lspconfig["pyright"].setup {
        on_attach = on_attach,
      }

      lspconfig["bashls"].setup {
        on_attach = on_attach,
      }

      lspconfig["jsonls"].setup {
        on_attach = on_attach,
      }

      lspconfig["lua_ls"].setup {
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                [vim.fn.stdpath "config" .. "/lua"] = true,
              },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    event = "BufReadPre",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
      },
    },
    opts = { ui = { icons = { package_installed = "", package_pending = "", package_uninstalled = "" } } },
    config = function(_, opts)
      require("mason").setup(opts)
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "pyright",
          "bashls",
          "jsonls",
          "clangd",
        },
      }
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = { "stylua", "cpplint", "clang_format", "black" },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        lazy = true,
      },
    },
    opts = function()
      local nls = require "null-ls"
      return {
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black
        },
      }
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
}
