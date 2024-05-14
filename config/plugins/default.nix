{ pkgs, ... }: {
  plugins.lazy.enable = true;

  imports = [
    ./catppuccin.nix
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
  #   comment.enable = true;
  #   indent-o-matic.enable = true;
  #   treesitter.enable = true;
  # };
}
