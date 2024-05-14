{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = lualine-nvim;

      event = "VeryLazy";

      dependencies = [
        gitsigns-nvim
        nvim-web-devicons
      ];

      config = true;

      opts.options.theme = "catppuccin";
    }
  ];
}
