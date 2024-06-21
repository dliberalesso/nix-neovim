{ treefmtPrograms }: final: _prev:
let
  pkgs = final;

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

    nvim-notify
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
  nvim-pkg = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
  };

  nvim-pkg-dev = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
    appName = "nvim-dev";
    dev = true;
  };
}
