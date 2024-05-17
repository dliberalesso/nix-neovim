{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = vim-just;
      ft = [ "just" ];
    }
  ];
}
