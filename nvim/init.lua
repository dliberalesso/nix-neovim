vim.loader.enable()

require("settings")

require("lz.n").load({
  "vim-startuptime",
  cmd = "StartupTime",
  before = function()
    vim.g.startuptime_tries = 10
  end,
})
