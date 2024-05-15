{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = tokyonight-nvim;

      lazy = false;
      priority = 1000;
    }
  ];
}
