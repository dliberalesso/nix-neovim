{ pkgs, ... }: {
  plugins.lazy.plugins = with pkgs.vimPlugins;
    let
      mini-module =
        { name
        , event ? [ ]
        , dependencies ? [ ]
        , opts ? { }
        }: {
          pkg = mini-nvim;
          name = name;
          inherit event;
          inherit dependencies;
          config = true;
          main = name;
          inherit opts;
        };
    in
    [
      (mini-module { name = "mini.basics"; })

      # (mini-module {name = "mini.extra";})

      (mini-module {
        name = "mini.indentscope";
        event = "VeryLazy";
      })

      (mini-module {
        name = "mini.statusline";
        event = "VeryLazy";
        dependencies = [ nvim-web-devicons ];
        opts.set_vim_settings = false;
      })

      (mini-module {
        name = "mini.trailspace";
        event = "VeryLazy";
      })
    ];
}
