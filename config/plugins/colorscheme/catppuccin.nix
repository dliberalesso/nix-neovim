{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = catppuccin-nvim;

      lazy = false;
      priority = 1000;

      config = true;
      main = "catppuccin";
      # config = /* lua */ ''
      #   function(_, opts)
      #     require("catppuccin").setup(opts)
      #   end
      # '';

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
