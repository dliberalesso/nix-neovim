---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/lazygit.nvim",

  dependencies = {
    { dir = vim.env.LAZY_ROOT_DIR .. "/plenary.nvim" },

    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<Leader>gg"] = { "<cmd>LazyGit<cr>", desc = "LazyGit" },
          },
        },
      },
    },
  },

  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
}
