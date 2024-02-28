{ inputs, pkgs, ... }:

{
  imports = [
    ./autocmds.nix
    ./keymaps.nix
    ./options.nix
  ];

  colorschemes.dracula.enable = true;

  editorconfig.enable = true;

  plugins = {
    bufferline.enable = true;
    lualine.enable = true;
    treesitter.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-sleuth
  ];

  extraConfigVim = ''
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
  '';
}
