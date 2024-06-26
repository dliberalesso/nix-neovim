---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      group = vim.g.icons_enabled ~= false and "" or "+",
      separator = "-",
    },
    disable = { filetypes = { "TelescopePrompt" } },
  },
}
