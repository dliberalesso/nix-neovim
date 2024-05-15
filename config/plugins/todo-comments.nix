{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = todo-comments-nvim;

      event = [ "BufReadPre" "BufNewFile" ];

      dependencies = [
        plenary-nvim
      ];

      config = true;
    }
  ];
}
