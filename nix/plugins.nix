{ pkgs }:
# Use this to create a plugin from a flake input
# mkNvimPlugin = src: pname:
#   pkgs.vimUtils.buildVimPlugin {
#     inherit pname src;
#     version = src.lastModifiedDate;
#   };

# This is the helper function that builds the Neovim derivation.
# mkNeovim = pkgs.callPackage ./mkNeovim.nix { };

# nvim-treesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (_:
#   let
#     treesitter-parser-paths =
#       pkgs.symlinkJoin {
#         name = "treesitter-parsers";
#         paths = nvim-treesitter.dependencies;
#       };
#   in
#   {
#     postPatch = ''
#       mkdir -p parser
#       cp -r ${treesitter-parser-paths.outPath}/parser/*.so parser
#     '';
#   });

# (mkNvimPlugin inputs.resession-nvim "resession.nvim")
[
  pkgs.vimPlugins.lz-n
  {
    plugin = pkgs.vimPlugins.vim-startuptime;
    optional = true;
  }
  # {
  #   plugin = nvim-treesitter;
  #   optional = true;
  # }
]
