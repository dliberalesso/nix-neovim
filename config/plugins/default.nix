{ inputs, pkgs, ... }:

{
  imports = [
    ./gitsigns.nix
    ./telescope.nix
    ./which-key.nix
  ];

  plugins = {
    comment-nvim.enable = true;
    bufferline.enable = true;
    lualine.enable = true;
    treesitter.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-sleuth
  ];
}