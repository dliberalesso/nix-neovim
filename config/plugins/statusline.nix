{pkgs, ...}: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = mini-nvim;
      name = "mini-statusline";

      event = "VeryLazy";

      dependencies = [
        nvim-web-devicons
      ];

      config = true;
      main = "mini.statusline";

      opts = {
        set_vim_settings = false;
      };
    }
  ];
}
