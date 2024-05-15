{
  plugins.lazy.enable = true;

  imports = [
    ./colorscheme
    ./comment.nix
    ./guess-indent.nix
    # ./gitsigns.nix
    ./incline.nix
    ./lazygit.nix
    # ./lualine.nix
    ./mini.nix
    ./neo-tree.nix
    ./telescope.nix
    ./treesitter.nix
    ./which-key.nix
  ];
}
