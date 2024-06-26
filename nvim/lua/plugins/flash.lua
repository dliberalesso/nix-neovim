---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/flash.nvim",

  event = "VeryLazy",

  dependencies = {
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",

      opts = function(_, opts)
        local maps = opts.mappings
        maps.x["s"] = {
          function() require("flash").jump() end,
          desc = "Flash",
        }
        maps.x["R"] = {
          function() require("flash").treesitter_search() end,
          desc = "Treesitter Search",
        }
        maps.x["S"] = {
          function() require("flash").treesitter() end,
          desc = "Flash Treesitter",
        }
        maps.o["r"] = {
          function() require("flash").remote() end,
          desc = "Remote Flash",
        }
        maps.o["R"] = {
          function() require("flash").treesitter_search() end,
          desc = "Treesitter Search",
        }
        maps.o["s"] = {
          function() require("flash").jump() end,
          desc = "Flash",
        }
        maps.o["S"] = {
          function() require("flash").treesitter() end,
          desc = "Flash Treesitter",
        }
        maps.n["s"] = {
          function() require("flash").jump() end,
          desc = "Flash",
        }
        maps.n["S"] = {
          function() require("flash").treesitter() end,
          desc = "Flash Treesitter",
        }
      end,
    },
  },
  config = true,
}
