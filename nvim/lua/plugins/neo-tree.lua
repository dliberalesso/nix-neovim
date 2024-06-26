---@type LazySpec
return {
  dir = vim.env.LAZY_ROOT_DIR .. "/neo-tree.nvim",

  dependencies = {
    { dir = vim.env.LAZY_ROOT_DIR .. "/plenary.nvim" },
    { dir = vim.env.LAZY_ROOT_DIR .. "/nvim-web-devicons" },
    { dir = vim.env.LAZY_ROOT_DIR .. "/nui.nvim" },
    -- "3rd/image.nvim",
    {
      dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
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
          function() require("neo-tree.command").execute({ action = "close" }) end,
          desc = "which_key_ignore",
        }
        maps.n["<leader>fe"] = {
          function() require("neo-tree.command").execute({ reveal = true, source = "filesystem" }) end,
          desc = "File Explorer",
        }
        maps.n["<leader>be"] = {
          function() require("neo-tree.command").execute({ reveal = true, source = "buffers" }) end,
          desc = "Buffer Explorer",
        }
        maps.n["<leader>ge"] = {
          function() require("neo-tree.command").execute({ reveal = true, source = "git_status" }) end,
          desc = "Git Explorer",
        }
        opts.autocmds.neotree_start = {
          {
            event = "BufEnter",
            desc = "Open Neo-Tree on startup with directory",
            callback = function()
              if package.loaded["neo-tree"] then
                return true
              else
                local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(0))
                if stats and stats.type == "directory" then
                  require("lazy").load({ plugins = { "neo-tree.nvim" } })
                  return true
                end
              end
            end,
          },
        }
        opts.autocmds.neotree_refresh = {
          {
            event = "TermClose",
            pattern = "*lazygit*",
            desc = "Refresh Neo-Tree sources when closing lazygit",
            callback = function()
              local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
              if manager_avail then
                for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
                  local module = "neo-tree.sources." .. source
                  if package.loaded[module] then manager.refresh(require(module).name) end
                end
              end
            end,
          },
        }
      end,
    },
  },

  cmd = "Neotree",

  opts = function()
    local astro, get_icon = require("astrocore"), require("astroui").get_icon

    local opts = {
      enable_git_status = true,
      enable_diagnostics = true,
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = {
          { source = "filesystem", display_name = get_icon("FolderClosed", 1, true) .. "File" },
          { source = "buffers", display_name = get_icon("DefaultFile", 1, true) .. "Bufs" },
          { source = "git_status", display_name = get_icon("Git", 1, true) .. "Git" },
          { source = "diagnostics", display_name = get_icon("Diagnostic", 1, true) .. "Diagnostic" },
        },
      },
      default_component_configs = {
        indent = {
          padding = 0,
          expander_collapsed = get_icon("FoldClosed"),
          expander_expanded = get_icon("FoldOpened"),
        },
        icon = {
          folder_closed = get_icon("FolderClosed"),
          folder_open = get_icon("FolderOpen"),
          folder_empty = get_icon("FolderEmpty"),
          folder_empty_open = get_icon("FolderEmpty"),
          default = get_icon("DefaultFile"),
        },
        modified = { symbol = get_icon("FileModified") },
        git_status = {
          symbols = {
            added = get_icon("GitAdd"),
            deleted = get_icon("GitDelete"),
            modified = get_icon("GitChange"),
            renamed = get_icon("GitRenamed"),
            untracked = get_icon("GitUntracked"),
            ignored = get_icon("GitIgnored"),
            unstaged = get_icon("GitUnstaged"),
            staged = get_icon("GitStaged"),
            conflict = get_icon("GitConflict"),
          },
        },
      },
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

          local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            astro.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
          }, function(choice)
            local result = vals[choice]
            if result then
              astro.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        system_open = function(state) vim.ui.open(state.tree:get_node():get_id()) end,
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
      filesystem = {
        follow_current_file = { enabled = true, leave_dirs_open = true },
        filtered_items = { hide_gitignored = true },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function(_)
            vim.opt_local.signcolumn = "auto"
            vim.opt_local.foldcolumn = "0"
          end,
        },
      },
    }

    if astro.is_available("telescope.nvim") then
      opts.commands.find_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("telescope.builtin").find_files({ cwd = path })
      end
      opts.window.mappings.F = "find_in_dir"
    end

    if astro.is_available("toggleterm.nvim") then
      local toggleterm_in_direction = function(state, direction)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        require("toggleterm.terminal").Terminal:new({ dir = path, direction = direction }):toggle()
      end
      local prefix = "T"
      ---@diagnostic disable-next-line: assign-type-mismatch
      opts.window.mappings[prefix] =
        { "show_help", nowait = false, config = { title = "New Terminal", prefix_key = prefix } }
      for suffix, direction in pairs({ f = "float", h = "horizontal", v = "vertical" }) do
        local command = "toggleterm_" .. direction
        opts.commands[command] = function(state) toggleterm_in_direction(state, direction) end
        opts.window.mappings[prefix .. suffix] = command
      end
    end

    return opts
  end,
}
