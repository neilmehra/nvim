local SERVERS = { "clangd", "pyright", "bashls", "jsonls", "lua_ls" }
local TOOLS = { "stylua", "black", "clang-format" } -- todo cpplint

return {
  -- LSP (Neovim 0.11+)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Global defaults for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = "rounded" },
      }

      -- LSP keymaps via LspAttach (buffer-local)
      local grp = vim.api.nvim_create_augroup("NeilLspKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = grp,
        callback = function(args)
          require("lsp.keymaps").attach(args.buf)
        end,
      })

      local rust = vim.g.rustaceanvim
      if type(rust) ~= "table" then
        rust = {}
      end
      rust.server = rust.server or {}
      rust.server.capabilities = capabilities
      vim.g.rustaceanvim = rust

      vim.lsp.config("clangd", {
        on_attach = function(client, _bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })

      vim.lsp.enable(SERVERS)
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      PATH = "append",
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = SERVERS,
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  -- none-ls
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local nls = require "null-ls"
      nls.setup {
        debug = true,
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          nls.builtins.formatting.clang_format,
        },
      }
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    opts = {
      ensure_installed = TOOLS,
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-null-ls").setup(opts)
    end,
  },

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
  },
}
