{ inputs, pkgs, ... }:

{
  imports = [];

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