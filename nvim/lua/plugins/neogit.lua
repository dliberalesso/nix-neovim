---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/neogit",

  dependencies = {
    { dir = vim.env.LAZY_ROOT_DIR .. "/plenary.nvim" },
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/diffview.nvim",
      cmd = "DiffviewOpen",
    },
    { dir = vim.env.LAZY_ROOT_DIR .. "/telescope.nvim" },
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>gn"] = { desc = require("astroui").get_icon("Neogit", 1, true) .. "Neogit" }
        maps.n["<Leader>gnt"] = { "<Cmd>Neogit<CR>", desc = "Open Neogit Tab Page" }
        maps.n["<Leader>gnc"] = { "<Cmd>Neogit commit<CR>", desc = "Open Neogit Commit Page" }
        maps.n["<Leader>gnd"] = { ":Neogit cwd=", desc = "Open Neogit Override CWD" }
        maps.n["<Leader>gnk"] = { ":Neogit kind=", desc = "Open Neogit Override Kind" }
      end,
    },
  },

  cmd = "Neogit",

  config = function()
    local fold_signs = { "", "" }

    require("neogit").setup({
      disable_builtin_notifications = true,
      telescope_sorter = function() return require("telescope").extensions.fzf.native_fzf_sorter() end,
      integrations = {
        diffview = true,
        telescope = true,
      },
      ---@diagnostic disable: missing-fields
      sections = { recent = { folded = false } },
      signs = { section = fold_signs, item = fold_signs },
    })
  end,
}
