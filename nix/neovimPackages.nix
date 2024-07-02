{ inputs, pkgs, treefmtPrograms }:
let
  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { };

  # Treesitter
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (_:
    let
      treesitter-parser-paths =
        pkgs.symlinkJoin {
          name = "treesitter-parsers";
          paths = nvim-treesitter.dependencies;
        };
    in
    {
      postPatch = ''
        mkdir -p parser
        cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
      '';
    });

  # Plugins
  plugins = with pkgs.vimPlugins; [
    lazy-nvim

    (mkNvimPlugin inputs.astrocore "astrocore")
    (mkNvimPlugin inputs.resession-nvim "resession.nvim")
    (mkNvimPlugin inputs.astrolsp "astrolsp")
    SchemaStore-nvim
    (mkNvimPlugin inputs.astroui "astroui")
    (mkNvimPlugin inputs.catppuccin-nvim "catppuccin")

    plenary-nvim
    promise-async
    nvim-nio
    nvim-web-devicons
    nui-nvim

    aerial-nvim
    alpha-nvim
    better-escape-nvim

    nvim-cmp
    cmp-buffer
    cmp-emoji
    cmp_luasnip
    cmp-path
    cmp-nvim-lsp
    luasnip
    friendly-snippets

    nvim-dap
    nvim-dap-ui
    cmp-dap

    dressing-nvim
    edgy-nvim
    flash-nvim

    diffview-nvim
    gitsigns-nvim
    lazygit-nvim
    neogit

    guess-indent-nvim
    heirline-nvim
    vim-illuminate
    indent-blankline-nvim

    nvim-lspconfig
    inc-rename-nvim
    lazydev-nvim
    (mkNvimPlugin inputs.luvit-meta "luvit-meta")
    lspkind-nvim
    none-ls-nvim

    (mkNvimPlugin inputs.mini-ai "mini.ai")
    (mkNvimPlugin inputs.mini-bufremove "mini.bufremove")
    (mkNvimPlugin inputs.mini-surround "mini.surround")

    neoconf-nvim
    neo-tree-nvim
    noice-nvim
    nvim-notify
    nvim-autopairs
    nvim-highlight-colors

    nvim-treesitter
    nvim-treesitter-textobjects
    nvim-ts-autotag
    rainbow-delimiters-nvim

    smart-splits-nvim

    telescope-nvim
    telescope-fzf-native-nvim
    telescope-manix

    todo-comments-nvim
    toggleterm-nvim
    trouble-nvim
    ts-comments-nvim
    nvim-ufo
    which-key-nvim
    nvim-window-picker
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
rec
{
  default = nvim;

  nvim = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
  };

  nvim-with-aliases = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
    appName = "nvim";
  };

  nvim-dev = mkNeovim {
    inherit extraPackages extraLuaPackages plugins neovim-unwrapped;
    appName = "nvim-dev";
    dev = true;
  };
}
