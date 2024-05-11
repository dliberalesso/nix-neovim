{pkgs, ...}: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = mini-nvim;
      name = "mini-indentscope";

      event = "VeryLazy";

      config = true;
      main = "mini.indentscope";
    }
  ];
}
