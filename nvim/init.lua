vim.loader.enable()

vim.o.number = true
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local lazyroot = vim.env.LAZY_ROOT_DIR
local lazypath = lazyroot .. "/lazy.nvim"

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  { import = "plugins" },
}, {
  root = lazyroot,
  defaults = { lazy = true, version = false },
  local_spec = true, -- load project specific .lazy.lua, which will be added at the end of the spec.
  lockfile = vim.fn.stdpath("cache") .. "/lazy-lock.json",
  install = {
    missing = false,
    colorscheme = { "catppuccin", "habamax" },
  },
  ui = { backdrop = 100 },
  diff = { cmd = "diffview.nvim" },
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
