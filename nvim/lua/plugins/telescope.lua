---@type LazySpec[]
return {
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/telescope.nvim",

    dependencies = {
      { dir = vim.env.LAZY_ROOT_DIR .. "/plenary.nvim" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/nvim-treesitter" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/telescope-fzf-native.nvim" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/telescope-manix" },
      {
        dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>f"] = vim.tbl_get(opts, "_map_sections", "f")
          if vim.fn.executable("git") == 1 then
            maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
            maps.n["<Leader>gb"] = {
              function() require("telescope.builtin").git_branches({ use_file_path = true }) end,
              desc = "Git branches",
            }
            maps.n["<Leader>gc"] = {
              function() require("telescope.builtin").git_commits({ use_file_path = true }) end,
              desc = "Git commits (repository)",
            }
            maps.n["<Leader>gC"] = {
              function() require("telescope.builtin").git_bcommits({ use_file_path = true }) end,
              desc = "Git commits (current file)",
            }
            maps.n["<Leader>gt"] =
              { function() require("telescope.builtin").git_status({ use_file_path = true }) end, desc = "Git status" }
          end
          maps.n["<Leader>f<CR>"] =
            { function() require("telescope.builtin").resume() end, desc = "Resume previous search" }
          maps.n["<Leader>f'"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
          maps.n["<Leader>f/"] = {
            function() require("telescope.builtin").current_buffer_fuzzy_find() end,
            desc = "Find words in current buffer",
          }
          maps.n["<Leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Find buffers" }
          maps.n["<Leader>fc"] =
            { function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor" }
          maps.n["<Leader>fC"] = { function() require("telescope.builtin").commands() end, desc = "Find commands" }
          maps.n["<Leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Find files" }
          maps.n["<Leader>fF"] = {
            function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end,
            desc = "Find all files",
          }
          maps.n["<Leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Find help" }
          maps.n["<Leader>fk"] = { function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" }
          maps.n["<Leader>fm"] = { function() require("telescope.builtin").man_pages() end, desc = "Find man" }
          maps.n["<Leader>fn"] = {
            function()
              local telescope = require("telescope")
              telescope.load_extension("notify")
              telescope.extensions.notify.notify()
            end,
            desc = "Find notifications",
          }
          maps.n["<Leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find history" }
          maps.n["<Leader>fr"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
          maps.n["<Leader>ft"] = {
            function() require("telescope.builtin").colorscheme({ enable_preview = true, ignore_builtins = true }) end,
            desc = "Find themes",
          }
          if vim.fn.executable("rg") == 1 then
            maps.n["<Leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" }
            maps.n["<Leader>fW"] = {
              function()
                require("telescope.builtin").live_grep({
                  additional_args = { "--hidden", "--no-ignore" },
                })
              end,
              desc = "Find words in all files",
            }
          end
          maps.n["<leader>fx"] = {
            function()
              local telescope = require("telescope")
              telescope.load_extension("manix")
              telescope.extensions.manix.manix()
            end,
            desc = "Find nix packages",
          }
          maps.n["<leader>fX"] = {
            function()
              local telescope = require("telescope")
              telescope.load_extension("manix")
              telescope.extensions.manix.manix({ cword = true })
            end,
            desc = "Find nix packages (current word)",
          }
          maps.n["<Leader>lD"] =
            { function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" }
          maps.n["<Leader>ls"] = {
            function()
              local telescope = require("telescope")
              telescope.load_extension("aerial")
              telescope.extensions.aerial.aerial()
            end,
            desc = "Search symbols",
          }
        end,
      },
    },

    cmd = "Telescope",

    opts = function()
      local actions, get_icon = require("telescope.actions"), require("astroui").get_icon
      local selected_icon = get_icon("Selected", 1)

      local open_selected = function(prompt_bufnr)
        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        local selected = picker:get_multi_selection()
        if vim.tbl_isempty(selected) then
          actions.select_default(prompt_bufnr)
        else
          actions.close(prompt_bufnr)
          for _, file in pairs(selected) do
            if file.path then vim.cmd("edit" .. (file.lnum and " +" .. file.lnum or "") .. " " .. file.path) end
          end
        end
      end

      local open_all = function(prompt_bufnr)
        actions.select_all(prompt_bufnr)
        open_selected(prompt_bufnr)
      end

      return {
        defaults = {
          git_worktrees = require("astrocore").config.git_worktrees,
          prompt_prefix = selected_icon,
          selection_caret = selected_icon,
          multi_icon = selected_icon,
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-N>"] = actions.cycle_history_next,
              ["<C-P>"] = actions.cycle_history_prev,
              ["<C-J>"] = actions.move_selection_next,
              ["<C-K>"] = actions.move_selection_previous,
              ["<CR>"] = open_selected,
              -- FIX: Keymap does not work (maybe wezterm stuff)
              -- ["<C-CR>"] = open_all,
            },
            n = {
              q = actions.close,
              ["<CR>"] = open_selected,
              -- FIX: Keymap does not work (maybe wezterm stuff)
              -- ["<C-CR>"] = open_all,
            },
          },
        },
        highlight = { enable = true },
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/astrolsp",
    optional = true,
    opts = function(_, opts)
      if require("astrocore").is_available("telescope.nvim") then
        local maps = opts.mappings
        maps.n["<Leader>lD"] = {
          function() require("telescope.builtin").diagnostics() end,
          desc = "Search diagnostics",
        }
        if maps.n.gd then
          maps.n.gd[1] = function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end
        end
        if maps.n.gI then
          maps.n.gI[1] = function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end
        end
        if maps.n["<Leader>lR"] then
          maps.n["<Leader>lR"][1] = function() require("telescope.builtin").lsp_references() end
        end
        if maps.n.gy then
          maps.n.gy[1] = function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end
        end
        if maps.n["<Leader>lG"] then
          maps.n["<Leader>lG"][1] = function()
            vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
              if query then
                -- word under cursor if given query is empty
                if query == "" then query = vim.fn.expand("<cword>") end
                require("telescope.builtin").lsp_workspace_symbols({
                  query = query,
                  prompt_title = ("Find word (%s)"):format(query),
                })
              end
            end)
          end
        end
      end
    end,
  },
}
