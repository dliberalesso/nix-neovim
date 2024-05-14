{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = comment-nvim;

      event = [ "BufReadPre" "BufNewFile" ];

      config = true;
    }
  ];
}
