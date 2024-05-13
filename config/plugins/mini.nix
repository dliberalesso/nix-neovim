{pkgs, ...}: {
  plugins.lazy.plugins = let
    mini-module = {
      name,
      event ? [],
    }: {
      pkg = pkgs.vimPlugins.mini-nvim;
      name = name;
      event = event;
      config = true;
      main = name;
    };
  in [
    (mini-module {name = "mini.basics";})

    # (mini-module {name = "mini.extra";})

    (mini-module {
      name = "mini.indentscope";
      event = "VeryLazy";
    })

    (mini-module {
      name = "mini.trailspace";
      event = "VeryLazy";
    })
  ];
}
