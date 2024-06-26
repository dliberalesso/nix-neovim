return {
  dir = vim.env.LAZY_ROOT_DIR .. "/nvim-highlight-colors",
  event = "User AstroFile",
  cmd = "HighlightColors",
  dependencies = {
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>uz"] = {
          function() vim.cmd.HighlightColors("Toggle") end,
          desc = "Toggle color highlight",
        }
      end,
    },
  },
  opts = { enabled_named_colors = false },
}
