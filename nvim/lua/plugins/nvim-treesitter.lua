---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/nvim-treesitter",
  main = "nvim-treesitter.configs",

  dependencies = {
    { dir = vim.env.LAZY_ROOT_DIR .. "/nvim-treesitter-textobjects" },
    { dir = vim.env.LAZY_ROOT_DIR .. "/nvim-ts-autotag" },
    { dir = vim.env.LAZY_ROOT_DIR .. "/rainbow-delimiters.nvim" },
  },

  event = "User AstroFile",

  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    require("lazy.core.loader").add_to_rtp(plugin)
    pcall(require, "nvim-treesitter.query_predicates")
  end,

  opts = {
    auto_install = false,
    ensure_installed = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = { enable = true },
    indent = { enable = true },
    matchup = {
      enable = true,
      enable_quotes = true,
      disable = { "c" }, -- disabled for slow parsers
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ak"] = { query = "@block.outer", desc = "around block" },
          ["ik"] = { query = "@block.inner", desc = "inside block" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "inside class" },
          ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
          ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
          ["af"] = { query = "@function.outer", desc = "around function " },
          ["if"] = { query = "@function.inner", desc = "inside function " },
          ["ao"] = { query = "@loop.outer", desc = "around loop" },
          ["io"] = { query = "@loop.inner", desc = "inside loop" },
          ["aa"] = { query = "@parameter.outer", desc = "around argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]k"] = { query = "@block.outer", desc = "Next block start" },
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
        },
        goto_next_end = {
          ["]K"] = { query = "@block.outer", desc = "Next block end" },
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
        },
        goto_previous_start = {
          ["[k"] = { query = "@block.outer", desc = "Previous block start" },
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
        },
        goto_previous_end = {
          ["[K"] = { query = "@block.outer", desc = "Previous block end" },
          ["[F"] = { query = "@function.outer", desc = "Previous function end" },
          ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          [">K"] = { query = "@block.outer", desc = "Swap next block" },
          [">F"] = { query = "@function.outer", desc = "Swap next function" },
          [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
        },
        swap_previous = {
          ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
          ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
          ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
        },
      },
    },
  },

  config = function(plugin, opts)
    local ts = require(plugin.main)

    -- disable all treesitter modules on large buffer
    if vim.tbl_get(require("astrocore").config, "features", "large_buf") then
      for _, module in ipairs(ts.available_modules()) do
        if not opts[module] then opts[module] = {} end
        local module_opts = opts[module]
        local disable = module_opts.disable
        module_opts.disable = function(lang, bufnr)
          return vim.b[bufnr].large_buf
            or (type(disable) == "table" and vim.tbl_contains(disable, lang))
            or (type(disable) == "function" and disable(lang, bufnr))
        end
      end
    end

    ts.setup(opts)
  end,
}
