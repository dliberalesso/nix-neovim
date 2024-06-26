vim.loader.enable()

require("utils.notify").init()

vim.opt.shada = ""
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.rtp:prepend(vim.env.LAZY_ROOT_DIR .. "/lazy.nvim")

require("lazy").setup({
  { import = "core" },
  { import = "plugins" },
}, {
  defaults = { lazy = true, version = false },
  local_spec = true, -- load project specific .lazy.lua, which will be added at the end of the spec.
  lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
  -- dev = {
  --   path = vim.env.LAZY_ROOT_DIR,
  --   patterns = { "nix" },
  --   fallback = false,
  -- },
  install = {
    missing = false,
    colorscheme = { "catppuccin", "habamax" },
  },
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "gzip",
        "zip",
        "zipPlugin",
        "tar",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "tohtml",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "matchit",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
        "matchparen",
        "spellfile",
        "osc52", -- Wezterm doesn't support osc52 yet
      },
    },
  },
})
