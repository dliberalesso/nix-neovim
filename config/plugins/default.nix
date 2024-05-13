{pkgs, ...}: {
  plugins.lazy.enable = true;

  imports = [
    ./catppuccin.nix
    ./git.nix
    # ./lazygit.nix
    ./mini.nix
    ./statusline.nix
    # ./nvim-tree.nix
    # ./telescope.nix
    # ./which-key.nix
  ];

  # plugins = {
  #   comment.enable = true;
  #   indent-o-matic.enable = true;
  #   treesitter.enable = true;
  # };
}
