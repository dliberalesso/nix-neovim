{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = guess-indent-nvim;

      event = [ "BufReadPre" "BufNewFile" ];

      config = true;
    }
  ];
}
