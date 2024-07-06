{ pkgs }:
# Use this to create a plugin from a flake input
# mkNvimPlugin = src: pname:
#   pkgs.vimUtils.buildVimPlugin {
#     inherit pname src;
#     version = src.lastModifiedDate;
#   };

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
with pkgs.vimPlugins; [
  vim-startuptime
  # {
  #   plugin = vim-startuptime;
  #   optional = true;
  # }
  # {
  #   plugin = nvim-treesitter;
  #   optional = true;
  # }
]
