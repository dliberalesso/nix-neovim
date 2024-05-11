{pkgs, ...}: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = catppuccin-nvim;

      lazy = false;
      priority = 1000;

      config = ''
        function(_, opts)
          require("catppuccin").setup(opts)

          vim.cmd.colorscheme("catppuccin")
        end
      '';

      opts = {
        flavour = "mocha";
        integrations.mini.enabled = true;
      };
    }
  ];
}
