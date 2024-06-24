---@type LazySpec[]
return {
  require("core.utils").core_spec("mappings", {
    opts = function(_, maps)
      maps.n["<leader>e"] = {
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd("p")
          else
            require("neo-tree.command").execute({ reveal = true, source = "last" })
          end
        end,
        desc = "Explorer",
      }
      maps.n["<leader>E"] = {
        function()
          require("neo-tree.command").execute({ action = "close" })
        end,
        desc = "which_key_ignore",
      }
      maps.n["<leader>fe"] = {
        function()
          require("neo-tree.command").execute({ reveal = true, source = "filesystem" })
        end,
        desc = "File Explorer",
      }
      maps.n["<leader>be"] = {
        function()
          require("neo-tree.command").execute({ reveal = true, source = "buffers" })
        end,
        desc = "Buffer Explorer",
      }
      maps.n["<leader>ge"] = {
        function()
          require("neo-tree.command").execute({ reveal = true, source = "git_status" })
        end,
        desc = "Git Explorer",
      }
    end,
  }),
  {
    dir = vim.env.LAZY_ROOT_DIR .. "/neo-tree.nvim",

    dependencies = {
      { dir = vim.env.LAZY_ROOT_DIR .. "/plenary.nvim" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/nvim-web-devicons" },
      { dir = vim.env.LAZY_ROOT_DIR .. "/nui.nvim" },
      -- "3rd/image.nvim",
    },

    cmd = "Neotree",

    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
        callback = function()
          local f = vim.fn.expand("%:p")
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd("Neotree current dir=" .. f)
            vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
          end
        end,
      })
    end,

    config = function()
      local icons = require("core.icons")

      --- TODO: Remove icons for diagnostic errors from here
      local defsign = vim.fn.sign_define
      defsign("DiagnosticSignError", { text = icons.DiagnosticError .. " ", texthl = "DiagnosticSignError" })
      defsign("DiagnosticSignWarn", { text = icons.DiagnosticWarn .. " ", texthl = "DiagnosticSignWarn" })
      defsign("DiagnosticSignInfo", { text = icons.DiagnosticInfo .. " ", texthl = "DiagnosticSignInfo" })
      defsign("DiagnosticSignHint", { text = icons.DiagnosticHint .. " ", texthl = "DiagnosticSignHint" })

      require("neo-tree").setup({
        auto_clean_after_session_restore = true,
        commands = {
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node:has_children() then
              if not node:is_expanded() then -- if unexpanded, expand
                state.commands.toggle_node(state)
              else -- if expanded and has children, seleect the next child
                if node.type == "file" then
                  state.commands.open(state)
                else
                  require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                end
              end
            else -- if has no children
              state.commands.open(state)
            end
          end,
          copy_selector = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local vals = {
              ["BASENAME"] = modify(filename, ":r"),
              ["EXTENSION"] = modify(filename, ":e"),
              ["FILENAME"] = filename,
              ["PATH (CWD)"] = modify(filepath, ":."),
              ["PATH (HOME)"] = modify(filepath, ":~"),
              ["PATH"] = filepath,
              ["URI"] = vim.uri_from_fname(filepath),
            }

            local options = vim.tbl_filter(function(val)
              return vals[val] ~= ""
            end, vim.tbl_keys(vals))
            if vim.tbl_isempty(options) then
              vim.notify("No values to copy", vim.log.levels.WARN)
              return
            end
            table.sort(options)
            vim.ui.select(options, {
              prompt = "Choose to copy to clipboard:",
              format_item = function(item)
                return ("%s: %s"):format(item, vals[item])
              end,
            }, function(choice)
              local result = vals[choice]
              if result then
                vim.notify(("Copied: `%s`"):format(result))
                vim.fn.setreg("+", result)
              end
            end)
          end,
          find_in_dir = function(state)
            local node = state.tree:get_node()
            local path = node.type == "file" and node:get_parent_id() or node:get_id()
            require("telescope.builtin").find_files({ cwd = path })
          end,
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if node:has_children() and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          system_open = function(state)
            vim.ui.open(state.tree:get_node():get_id())
          end,
        },
        close_if_last_window = true,
        default_component_configs = {
          indent = {
            padding = 0,
            expander_collapsed = icons.FoldClosed,
            expander_expanded = icons.FoldOpened,
          },
          icon = {
            folder_closed = icons.FolderClosed,
            folder_open = icons.FolderOpen,
            folder_empty = icons.FolderEmpty,
            folder_empty_open = icons.FolderEmpty,
            default = icons.DefaultFile,
          },
          modified = { symbol = icons.FileModified },
          git_status = {
            symbols = {
              added = icons.GitAdd,
              deleted = icons.GitDelete,
              modified = icons.GitChange,
              renamed = icons.GitRenamed,
              untracked = icons.GitUntracked,
              ignored = icons.GitIgnored,
              unstaged = icons.GitUnstaged,
              staged = icons.GitStaged,
              conflict = icons.GitConflict,
            },
          },
        },
        enable_diagnostics = true,
        enable_git_status = true,
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_)
              vim.opt_local.signcolumn = "auto"
              vim.opt_local.foldcolumn = "0"
            end,
          },
        },
        filesystem = {
          filtered_items = { hide_gitignored = true },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
        },
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        source_selector = {
          winbar = true,
          content_layout = "center",
          sources = {
            { source = "filesystem", display_name = icons.FolderClosed .. " File" },
            { source = "buffers", display_name = icons.DefaultFile .. " Bufs" },
            { source = "git_status", display_name = icons.Git .. " Git" },
            { source = "diagnostics", display_name = icons.Diagnostic .. " Diagnostic" },
          },
        },
        window = {
          fuzzy_finder_mappings = {
            ["<C-j>"] = "move_cursor_down",
            ["<C-k>"] = "move_cursor_up",
          },
          mappings = {
            ["<space>"] = "none",
            ["<S-CR>"] = "system_open",
            ["l"] = "child_or_open",
            ["h"] = "parent_or_close",
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
            ["F"] = "find_in_dir",
            ["Y"] = "copy_selector",
            ["O"] = "system_open",
          },
          width = 30,
        },
      })
    end,
  },
}
