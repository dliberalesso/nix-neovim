{ pkgs, ... }: {
  plugins.lazy.enable = true;

  imports = [
    ./catppuccin.nix
    ./comment.nix
    ./guess-indent.nix
    ./git.nix
    ./incline.nix
    # ./lazygit.nix
    ./lualine.nix
    ./mini.nix
    # ./nvim-tree.nix
    # ./telescope.nix
    ./treesitter.nix
    # ./which-key.nix
  ];

  # plugins = {
  #   indent-o-matic.enable = true;
  #   treesitter.enable = true;
  # };
}
