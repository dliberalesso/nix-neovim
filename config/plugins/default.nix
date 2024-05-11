{pkgs, ...}: {
  plugins.lazy.enable = true;

  imports = [
    ./catppuccin.nix
    ./git.nix
    ./indentscope.nix
    # ./lazygit.nix
    # ./lualine.nix
    ./statusline.nix
    # ./nvim-tree.nix
    ./tabline.nix
    # ./telescope.nix
    # ./which-key.nix
  ];

  # plugins = {
  #   comment.enable = true;
  #   indent-o-matic.enable = true;
  #   treesitter.enable = true;
  # };
}
