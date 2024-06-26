return {
  dir = vim.env.LAZY_ROOT_DIR .. "/nvim-window-picker",
  main = "window-picker",
  opts = { picker_config = { statusline_winbar_picker = { use_winbar = "smart" } } },
}
