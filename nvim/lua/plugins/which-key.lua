---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/which-key.nvim",

  event = "VeryLazy",

  config = function(_, opts)
    local wk = require("which-key")

    wk.setup({
      icons = {
        group = "",
        separator = "-",
      },
      disable = { filetypes = { "TelescopePrompt" } },
    })

    wk.register({
      f = { name = "File" },
      b = { name = "Buffer" },
      g = { name = "Git" },
      l = { name = "LSP" },
      p = { name = "Packages" },
    }, { prefix = "<leader>" })
  end,
}
