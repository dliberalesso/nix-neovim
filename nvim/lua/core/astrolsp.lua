---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/astrolsp",

  dependencies = { dir = vim.env.LAZY_ROOT_DIR .. "/SchemaStore.nvim" },

  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      features = {
        codelens = true,
        inlay_hints = false,
        semantic_tokens = true,
      },
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      config = {
        jsonls = {
          on_new_config = function(config)
            if not config.settings.json.schemas then config.settings.json.schemas = {} end
            vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = { json = { validate = { enable = true } } },
        },
        lua_ls = {
          settings = {
            Lua = {
              format = { enable = false },
              globals = {
                "vim",
                "describe",
                "it",
                "assert",
                "stub",
              },
              disable = { "duplicate-set-field" },
              hint = { enable = true, arrayIndex = "Disable" },
              runtime = { version = "LuaJIT" },
              workspace = { checkThirdParty = false },
            },
          },
        },
        yamlls = {
          on_new_config = function(config)
            if not config.settings.yaml.schemas then config.settings.yaml.schemas = {} end
            vim.list_extend(config.settings.yaml.schemas, require("schemastore").yaml.schemas())
          end,
          settings = { yaml = { schemaStore = { enable = false, url = "" } } },
        },
      },
      flags = {},
      formatting = { format_on_save = { enabled = true }, disabled = {} },
      handlers = { function(server, server_opts) require("lspconfig")[server].setup(server_opts) end },
      lsp_handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", silent = true }),
        ["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          { border = "rounded", silent = true }
        ),
      },
      servers = {
        "jsonls",
        "lua_ls",
        "marksman",
        "nixd",
        "taplo",
        "yamlls",
      },
      on_attach = nil,
    } --[[@as AstroLSPOpts]])
  end,
}
