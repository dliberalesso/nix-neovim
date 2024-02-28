{
  plugins.telescope = {
    enable = true;

    extensions = {
      fzf-native.enable = true;

      ui-select = {
        enable = true;
        settings.specific_opts.codeactions = true;
      };
    };

    keymaps = {
      "<leader>sh" = {
        action = "help_tags, {}";
        desc = "[S]earch [H]elp";
      };

      "<leader>sk" = {
        action = "keymaps, {}";
        desc = "[S]earch [K]eymaps";
      };

      "<leader>sf" = {
        action = "find_files, {}";
        desc = "[S]earch [F]iles";
      };

      "<leader>ss" = {
        action = "builtin, {}";
        desc = "[S]earch [S]elect Telescope";
      };

      "<leader>sw" = {
        action = "grep_string, {}";
        desc = "[S]earch current [W]ord";
      };

      "<leader>sg" = {
        action = "live_grep, {}";
        desc = "[S]earch by [G]rep";
      };

      "<leader>sd" = {
        action = "diagnostics, {}";
        desc = "[S]earch [D]iagnostics";
      };

      "<leader>sr" = {
        action = "resume, {}";
        desc = "[S]earch [R]esume";
      };

      "<leader>s." = {
        action = "oldfiles, {}";
        desc = "[S]earch Recent Files ('.' for repeat)";
      };

      "<leader><leader>" = {
        action = "buffers, {}";
        desc = "[ ] Find existing buffers";
      };
    };
  };

  keymaps = [
    # Fuzzily search in current buffer
    {
      mode = "n";
      key = "<leader>/";
      action = ''
        function()
          require('telescope.builtin')
          .current_buffer_fuzzy_find(require('telescope.themes')
          .get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end
      '';
      lua = true;
      options.desc = "[/] Fuzzily search in current buffer";
    }

    # Search in Open Files
    {
      mode = "n";
      key = "<leader>s/";
      action = ''
        function()
          require('telescope.builtin')
          .live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end
      '';
      lua = true;
      options.desc = "[S]earch [/] in Open Files";
    }
  ];
}
