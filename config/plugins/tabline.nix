{pkgs, ...}: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = mini-nvim;
      name = "mini-tabline";

      event = "VeryLazy";

      dependencies = [
        nvim-web-devicons
      ];

      config = true;
      main = "mini.tabline";
    }
  ];
}
