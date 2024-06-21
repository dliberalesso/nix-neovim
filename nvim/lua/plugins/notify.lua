---@return LazySpec[]
return {
  require("core.utils").core_spec("mappings", {
    opts = function(_, maps)
      maps.n["<Leader>uD"] = {
        function()
          require("notify").dismiss({ pending = true, silent = true })
        end,
        desc = "Dismiss notifications",
      }
    end,
  }),
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/nvim-notify",

    dependencies = {
      { dir = vim.env.LAZY_ROOT_DIR .. "/plenary.nvim" },
    },

    init = function()
      require("core.utils").load_plugin_with_func("nvim-notify", vim, "notify")
    end,

    config = function()
      local notify = require("notify")

      notify.setup({
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "󰋼",
          TRACE = "󰌵",
          WARN = "",
        },

        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,

        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,

        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 175 })

          require("lazy").load({ plugins = { "nvim-treesitter" } })

          vim.wo[win].conceallevel = 3

          local buf = vim.api.nvim_win_get_buf(win)

          vim.treesitter.start(buf, "markdown")

          vim.wo[win].spell = false
        end,
      })

      require("core.notify").setup(notify)
    end,
  },
}
