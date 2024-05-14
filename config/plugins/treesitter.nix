{ pkgs, ... }:
let
  allParsers = with pkgs.vimPlugins;
    builtins.filter
      (p: p.pkg ? type && p.pkg.type == "derivation")
      (builtins.map
        (name: {
          pkg = nvim-treesitter-parsers.${name};
          ft = [ name ];
        })
        (builtins.attrNames nvim-treesitter-parsers));
in
{
  plugins.lazy.plugins = with pkgs.vimPlugins;
    allParsers
    ++ [
      {
        pkg = nvim-treesitter;

        event = [ "BufReadPost" "BufNewFile" ];

        dependencies = [
          nvim-treesitter-textobjects
          rainbow-delimiters-nvim
          # Parsers that should be auto-loaded. These are ones that can be
          # embedded into other languages or are just so common.
          nvim-treesitter-parsers.bash
          nvim-treesitter-parsers.lua
          nvim-treesitter-parsers.markdown
          nvim-treesitter-parsers.markdown_inline
          nvim-treesitter-parsers.regex
          nvim-treesitter-parsers.vimdoc
        ];

        config = /* lua */ ''
          function()
            require("nvim-treesitter.configs").setup({
              ensure_installed = {},
              auto_install = false,
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
              indent = { enable = true },
            })
          end
        '';
      }
    ];
}
