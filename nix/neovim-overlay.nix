# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ treefmtPrograms }: final: _prev:
let
  pkgs = final;

  # Use this to create a plugin from a flake input

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { };

  # Treesitter
  treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (_:
    let
      treesitter-parser-paths =
        pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = treesitter.dependencies;
        };
    in
    {
      postPatch = ''
        mkdir -p parser
        cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
      '';
    });

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  plugins = with pkgs.vimPlugins; [
    lazy-nvim
    diffview-nvim
    vim-startuptime

    plenary-nvim
    nvim-web-devicons
    nui-nvim

    catppuccin-nvim

    treesitter
    nvim-treesitter-textobjects
    nvim-ts-autotag
    rainbow-delimiters-nvim

    neo-tree-nvim

    telescope-nvim
    telescope-fzf-native-nvim

    which-key-nvim
  ];

  extraPackages = [
    # Formatters
    pkgs.prettierd

    # Language Servers
    pkgs.lua-language-server
    pkgs.marksman
    pkgs.nixd
    pkgs.vscode-langservers-extracted
    pkgs.yaml-language-server

    # Linters/Static analyzers
    pkgs.selene
  ] ++ treefmtPrograms;

  extraLuaPackages = p: [
    p.jsregexp
  ];

  neovim-unwrapped = pkgs.neovim;
in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
  };

  nvim-pkg-dev = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
    appName = "nvim-dev";
    dev = true;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    inherit plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}