---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/nvim-autopairs",

  dependencies = {
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",

      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>ua"] = { function() require("astrocore.toggles").autopairs() end, desc = "Toggle autopairs" }
      end,
    },
  },

  event = "User AstroFile",

  opts = {
    check_ts = true,
    ts_config = { java = false },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = ([[ [%'%"%)%>%]%)%}%,] ]]):gsub("%s+", ""),
      offset = 0,
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  },

  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    local astrocore = require("astrocore")
    if not astrocore.config.features.autopairs then npairs.disable() end
    astrocore.on_load(
      "nvim-cmp",
      function()
        require("cmp").event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done({ tex = false })
        )
      end
    )
  end,
}
