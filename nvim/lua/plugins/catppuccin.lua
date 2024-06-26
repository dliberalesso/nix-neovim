---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/catppuccin",

  ---@type CatppuccinOptions
  opts = {
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dap = true,
      dap_ui = true,
      gitsigns = true,
      illuminate = true,
      indent_blankline = true,
      markdown = true,
      mini = {
        enabled = true,
        indentscope_color = "mauve",
      },
      native_lsp = { enabled = true },
      neogit = true,
      neotree = true,
      notify = true,
      rainbow_delimiters = true,
      semantic_tokens = true,
      symbols_outline = true,
      telescope = true,
      treesitter = true,
      ts_rainbow = false,
      ufo = true,
      which_key = true,
      window_picker = true,
    },
  },
}
