{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = neo-tree-nvim;

      dependencies = [
        plenary-nvim
        nvim-web-devicons
        nui-nvim
        image-nvim
      ];

      config = true;
    }
  ];
}
