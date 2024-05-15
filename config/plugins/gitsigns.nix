{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = gitsigns-nvim;

      event = [ "BufReadPre" "BufNewFile" ];

      config = true;
    }
  ];
}
