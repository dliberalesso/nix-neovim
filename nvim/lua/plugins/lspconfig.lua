return {
  dir = vim.env.LAZY_ROOT_DIR .. "/nvim-lspconfig",
  dependencies = {
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrolsp",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>li"] =
          { "<Cmd>LspInfo<CR>", desc = "LSP information", cond = function() return vim.fn.exists(":LspInfo") > 0 end }
      end,
    },
    { dir = vim.env.LAZY_ROOT_DIR .. "/neoconf.nvim", opts = {} },
  },
  cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
    if require("astrocore").is_available("neoconf.nvim") then table.insert(cmds, "Neoconf") end
    vim.list_extend(cmds, { "LspInfo", "LspLog", "LspStart" }) -- add normal `nvim-lspconfig` commands
  end,
  event = "User AstroFile",
  config = function(_, _)
    local setup_servers = function()
      vim.tbl_map(require("astrolsp").lsp_setup, require("astrolsp").config.servers)
      require("astrocore").exec_buffer_autocmds("FileType", { group = "lspconfig" })

      require("astrocore").event("LspSetup")
    end
    local astrocore = require("astrocore")
    if astrocore.is_available("mason-lspconfig.nvim") then
      astrocore.on_load("mason-lspconfig.nvim", setup_servers)
    else
      setup_servers()
    end
  end,
}
