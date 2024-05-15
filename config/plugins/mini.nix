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
          inherit name;
          inherit event;
          inherit dependencies;
          config = true;
          main = name;
          inherit opts;
        };
    in
    [
      (mini-module {
        name = "mini.ai";
        event = [ "BufReadPre" "BufNewFile" ];
        opts.n_lines = 500;
      })

      (mini-module {
        name = "mini.align";
        event = [ "BufReadPre" "BufNewFile" ];
      })

      (mini-module { name = "mini.basics"; })

      (mini-module {
        name = "mini.comment";
        event = [ "BufReadPre" "BufNewFile" ];
      })

      (mini-module {
        name = "mini.diff";
        event = [ "BufReadPre" "BufNewFile" ];
        opts.view.style = "sign";
      })

      # (mini-module {name = "mini.extra";})

      (mini-module {
        name = "mini.indentscope";
        event = [ "BufReadPre" "BufNewFile" ];
      })

      (mini-module {
        name = "mini.statusline";
        event = "VeryLazy";
        dependencies = [ nvim-web-devicons ];
        opts.set_vim_settings = false;
      })

      (mini-module {
        name = "mini.surround";
        event = [ "BufReadPre" "BufNewFile" ];
      })

      (mini-module {
        name = "mini.trailspace";
        event = [ "BufReadPre" "BufNewFile" ];
      })
    ];
}
