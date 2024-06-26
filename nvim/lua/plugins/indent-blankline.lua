return {
  dir = vim.env.LAZY_ROOT_DIR .. "/indent-blankline.nvim",
  event = "User AstroFile",
  cmd = { "IBLEnable", "IBLDisable", "IBLToggle", "IBLEnableScope", "IBLDisableScope", "IBLToggleScope" },
  dependencies = {
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>u|"] = { "<Cmd>IBLToggle<CR>", desc = "Toggle indent guides" }
      end,
    },
  },
  main = "ibl",
  opts = {
    indent = { char = "▏" },
    scope = { show_start = false, show_end = false },
    exclude = {
      buftypes = {
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
      filetypes = {
        "aerial",
        "alpha",
        "dashboard",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "NvimTree",
        "neogitstatus",
        "notify",
        "startify",
        "toggleterm",
        "Trouble",
      },
    },
  },
}
