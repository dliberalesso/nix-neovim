---@type LazySpec[]
return {
  {
    "nix/telescope.nvim",

    dependencies = {
      "nix/plenary.nvim",
      "nix/telescope-fzf-native.nvim",
      "nix/nvim-treesitter",
    },

    cmd = "Telescope",

    opts = function()
      local actions = require("telescope.actions")
      local selected_icon = "❯ "
      return {
        defaults = {
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
            },
            n = { q = actions.close },
          },
        },
        highlight = {
          enable = true,
          -- additional_vim_regex_highlighting = false,
        },
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      telescope.load_extension("fzf")
    end,
  },
  require("core.utils").core_spec("mappings", {
    opts = function(_, maps)
      maps.n["<leader>gb"] = {
        function()
          require("telescope.builtin").git_branches({ use_file_path = true })
        end,
        desc = "Git branches",
      }
      maps.n["<leader>gc"] = {
        function()
          require("telescope.builtin").git_commits({ use_file_path = true })
        end,
        desc = "Git commits (repository)",
      }
      maps.n["<leader>gC"] = {
        function()
          require("telescope.builtin").git_bcommits({ use_file_path = true })
        end,
        desc = "Git commits (current file)",
      }
      maps.n["<leader>gt"] = {
        function()
          require("telescope.builtin").git_status({ use_file_path = true })
        end,
        desc = "Git status",
      }
      maps.n["<leader>f<CR>"] = {
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume previous search",
      }
      maps.n["<leader>f'"] = {
        function()
          require("telescope.builtin").marks()
        end,
        desc = "Find marks",
      }
      maps.n["<leader>f/"] = {
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Find words in current buffer",
      }
      maps.n["<leader>fb"] = {
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find buffers",
      }
      maps.n["<leader>fc"] = {
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Find word under cursor",
      }
      maps.n["<leader>fC"] = {
        function()
          require("telescope.builtin").commands()
        end,
        desc = "Find commands",
      }
      maps.n["<leader>ff"] = {
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find files",
      }
      maps.n["<leader>fF"] = {
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
        end,
        desc = "Find all files",
      }
      maps.n["<leader>fh"] = {
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find help",
      }
      maps.n["<leader>fk"] = {
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "Find keymaps",
      }
      maps.n["<leader>fm"] = {
        function()
          require("telescope.builtin").man_pages()
        end,
        desc = "Find man",
      }
      maps.n["<Leader>fn"] = {
        function()
          local telescope = require("telescope")
          telescope.load_extension("notify")
          telescope.extensions.notify.notify()
        end,
        desc = "Find notifications",
      }
      maps.n["<leader>fo"] = {
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Find history",
      }
      maps.n["<leader>fr"] = {
        function()
          require("telescope.builtin").registers()
        end,
        desc = "Find registers",
      }
      maps.n["<leader>ft"] = {
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true, ignore_builtins = true })
        end,
        desc = "Find themes",
      }
      maps.n["<leader>fw"] = {
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find words",
      }
      maps.n["<leader>fW"] = {
        function()
          require("telescope.builtin").live_grep({
            additional_args = function(args)
              return vim.list_extend(args, { "--hidden", "--no-ignore" })
            end,
          })
        end,
        desc = "Find words in all files",
      }
      maps.n["<leader>fx"] = {
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Config Files",
            cwd = vim.fn.stdpath("config"),
            follow = true,
          })
        end,
        desc = "Find Nvim config files",
      }
      maps.n["<leader>ls"] = {
        function()
          -- TODO: Delete if we won't use `aerial.nvim
          -- local telescope = require "telescope"
          -- telescope.load_extension "aerial"
          -- telescope.extensions.aerial.aerial()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Search symbols",
      }
    end,
  }),
  -- {
  --   "AstroNvim/astrolsp",
  --   optional = true,
  --   opts = function(_, opts)
  --     if require("astrocore").is_available "telescope.nvim" then
  --       local maps = opts.mappings
  --       maps.n["<Leader>lD"] = {
  --         function()
  --           require("telescope.builtin").diagnostics()
  --         end,
  --         desc = "Search diagnostics",
  --       }
  --       if maps.n.gd then
  --         maps.n.gd[1] = function()
  --           require("telescope.builtin").lsp_definitions { reuse_win = true }
  --         end
  --       end
  --       if maps.n.gI then
  --         maps.n.gI[1] = function()
  --           require("telescope.builtin").lsp_implementations { reuse_win = true }
  --         end
  --       end
  --       if maps.n["<Leader>lR"] then
  --         maps.n["<Leader>lR"][1] = function()
  --           require("telescope.builtin").lsp_references()
  --         end
  --       end
  --       if maps.n.gy then
  --         maps.n.gy[1] = function()
  --           require("telescope.builtin").lsp_type_definitions { reuse_win = true }
  --         end
  --       end
  --       if maps.n["<Leader>lG"] then
  --         maps.n["<Leader>lG"][1] = function()
  --           vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
  --             if query then
  --               -- word under cursor if given query is empty
  --               if query == "" then
  --                 query = vim.fn.expand "<cword>"
  --               end
  --               require("telescope.builtin").lsp_workspace_symbols {
  --                 query = query,
  --                 prompt_title = ("Find word (%s)"):format(query),
  --               }
  --             end
  --           end)
  --         end
  --       end
  --     end
  --   end,
  -- },
}