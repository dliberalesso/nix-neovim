---@type LazySpec
return {
  "catppuccin/nvim",
  name = "catppuccin",

  lazy = false,
  priority = 1000,

  config = function()
    require("catppuccin").setup()
    vim.cmd.colorscheme("catppuccin")
  end,

  ---@type CatppuccinOptions
  opts = {
    integrations = {
      -- aerial = true,
      -- alpha = true,
      -- cmp = true,
      -- dap = true,
      -- dap_ui = true,
      -- diffview = true,
      -- gitsigns = true,
      -- illuminate = true,
      -- indent_blankline = true,
      -- markdown = true,
      -- mini = { enabled = true },
      native_lsp = { enabled = true },
      -- neotree = true,
      -- notify = true,
      -- rainbow_delimiters = true,
      semantic_tokens = true,
      symbols_outline = true,
      -- telescope = true,
      treesitter = true,
      -- ufo = true,
      -- which_key = true,
      -- window_picker = true,
    },
  },
}