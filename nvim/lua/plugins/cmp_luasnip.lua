local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local function is_visible(cmp) return cmp.core.view:visible() or vim.fn.pumvisible() == 1 end

---@type LazySpec[]
return {
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/nvim-cmp",

    dependencies = {
      {
        dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>uc"] =
            { function() require("astrocore.toggles").buffer_cmp() end, desc = "Toggle autocompletion (buffer)" }
          maps.n["<Leader>uC"] =
            { function() require("astrocore.toggles").cmp() end, desc = "Toggle autocompletion (global)" }
        end,
      },
      { dir = vim.env.LAZY_ROOT_DIR .. "/cmp-buffer" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/cmp-path" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/cmp-nvim-lsp" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/lspkind-nvim" },
    },

    event = "InsertCharPre",

    opts = function()
      local cmp, astro = require("cmp"), require("astrocore")

      local sources = {}
      for source_plugin, source in pairs({
        ["cmp-buffer"] = { name = "buffer", priority = 500, group_index = 2 },
        ["cmp-nvim-lsp"] = { name = "nvim_lsp", priority = 1000 },
        ["cmp-path"] = { name = "path", priority = 250 },
      }) do
        if astro.is_available(source_plugin) then table.insert(sources, source) end
      end

      return {
        enabled = function()
          local dap_prompt = astro.is_available("cmp-dap") -- add interoperability with cmp-dap
            and vim.tbl_contains({ "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo[0].filetype)
          if vim.bo[0].buftype == "prompt" and not dap_prompt then return false end
          return vim.F.if_nil(vim.b.cmp_enabled, astro.config.features.cmp)
        end,
        preselect = cmp.PreselectMode.None,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = require("lspkind").cmp_format({
            mode = "symbol",
            symbol_map = {
              Array = "󰅪",
              Boolean = "⊨",
              Class = "󰌗",
              Constructor = "",
              Key = "󰌆",
              Namespace = "󰅪",
              Null = "NULL",
              Number = "#",
              Object = "󰀚",
              Package = "󰏗",
              Property = "",
              Reference = "",
              Snippet = "",
              String = "󰀬",
              TypeParameter = "󰊄",
              Unit = "",
            },
            menu = {},
          }),
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp.config.window.bordered({
            col_offset = -2,
            side_padding = 0,
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          }),
        },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-P>"] = cmp.mapping(function()
            if is_visible(cmp) then
              cmp.select_prev_item()
            else
              cmp.complete()
            end
          end),
          ["<C-N>"] = cmp.mapping(function()
            if is_visible(cmp) then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end),
          ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-U>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-D>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-Y>"] = cmp.config.disable,
          ["<C-E>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if is_visible(cmp) then
              cmp.select_next_item()
            elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet and vim.snippet.active({ direction = 1 }) then
              vim.schedule(function() vim.snippet.jump(1) end)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if is_visible(cmp) then
              cmp.select_prev_item()
            elseif vim.api.nvim_get_mode().mode ~= "c" and vim.snippet and vim.snippet.active({ direction = -1 }) then
              vim.schedule(function() vim.snippet.jump(-1) end)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = sources,
      }
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources or {}) do
        if not source.group_index then source.group_index = 1 end
      end
      require("cmp").setup(opts)
    end,
  },
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/astrolsp",

    optional = true,

    opts = function(_, opts)
      local astrocore = require("astrocore")
      if astrocore.is_available("cmp-nvim-lsp") then
        opts.capabilities = astrocore.extend_tbl(opts.capabilities, {
          textDocument = {
            completion = {
              completionItem = {
                documentationFormat = { "markdown", "plaintext" },
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                deprecatedSupport = true,
                commitCharactersSupport = true,
                tagSupport = { valueSet = { 1 } },
                resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
              },
            },
          },
        })
      end
    end,
  },
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/luasnip",

    dependencies = {
      { dir = vim.env.LAZY_ROOT_DIR .. "/friendly-snippets" },
      {
        dir = vim.env.LAZY_ROOT_DIR .. "/nvim-cmp",

        dependencies = { dir = vim.env.LAZY_ROOT_DIR .. "/cmp_luasnip" },

        opts = function(_, opts)
          local luasnip, cmp = require("luasnip"), require("cmp")

          if not opts.snippet then opts.snippet = {} end
          opts.snippet.expand = function(args) luasnip.lsp_expand(args.body) end

          if not opts.sources then opts.sources = {} end
          table.insert(opts.sources, { name = "luasnip", priority = 750 })

          if not opts.mappings then opts.mappings = {} end
          opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
            if is_visible(cmp) then
              cmp.select_next_item()
            elseif vim.api.nvim_get_mode().mode ~= "c" and luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" })
          opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
            if is_visible(cmp) then
              cmp.select_prev_item()
            elseif vim.api.nvim_get_mode().mode ~= "c" and luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      if opts then require("luasnip").config.setup(opts) end
      vim.tbl_map(
        function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
        { "vscode", "snipmate", "lua" }
      )
    end,
  },
}
