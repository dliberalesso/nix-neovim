return {
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/lazydev.nvim",
    dependencies = { { dir = vim.env.LAZY_ROOT_DIR .. "/luvit-meta" } },
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "astrocore", words = { "AstroCore" } },
        { path = "astrolsp", words = { "AstroLSP" } },
        { path = "astroui", words = { "AstroUI" } },
        { path = "astrotheme", words = { "AstroTheme" } },
        { path = "lazy.nvim", words = { "Lazy" } },
        { path = "catppuccin", word = { "Catppuccin" } },
      },
    },
  },
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/nvim-cmp",
    opts = function(_, opts) table.insert(opts.sources, { name = "lazydev", group_index = 0 }) end,
  },
}
