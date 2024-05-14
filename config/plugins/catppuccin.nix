{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = catppuccin-nvim;

      lazy = false;
      priority = 1000;

      config = /* lua */ ''
        function(_, opts)
          require("catppuccin").setup(opts)

          vim.cmd.colorscheme("catppuccin")
        end
      '';

      opts = {
        flavour = "mocha";
        integrations = {
          gitsigns = true;
          mini.enabled = true;
          treesitter = true;
          which_key = true;
        };
      };
    }
  ];
}
