-- vim.opt.shada = ""

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.number = true

require("lz.n").load({
  "vim-startuptime",
  cmd = "StartupTime",
  before = function() vim.g.startuptime_tries = 10 end,
})
