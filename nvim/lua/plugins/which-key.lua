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

    icons = require("core.icons")

    wk.register({
      b = { name = icons.Tab .. " Buffers" },
      bs = { name = icons.Sort .. " Sort Buffers" },
      d = { name = icons.Debugger .. " Debugger" },
      f = { name = icons.Search .. " Find" },
      g = { name = icons.Git .. " Git" },
      l = { name = icons.ActiveLSP .. " LSP" },
      p = { name = icons.Package .. " Plugins" },
      S = { name = icons.Session .. " Session" },
      t = { name = icons.Terminal .. " Terminal" },
      u = { name = icons.Window .. " UI/UX" },
    }, { prefix = "<leader>" })
  end,
}
