---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/better-escape.nvim",
  event = "InsertCharPre",
  opts = { timeout = 300 },
}
