return {
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/lspkind-nvim",
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
      },
      menu = {},
    },
    config = function(_, opts) require("lspkind").init(opts) end,
  },
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/nvim-cmp",
    opts = function(_, opts)
      if require("astrocore").is_available("lspkind.nvim") then
        if not opts.formatting then opts.formatting = {} end
        opts.formatting.format = require("lspkind").cmp_format(require("astrocore").plugin_opts("lspkind.nvim"))
      end
    end,
  },
}
