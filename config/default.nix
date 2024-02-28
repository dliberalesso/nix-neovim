{ inputs, pkgs, ... }:

{
  imports = [
    ./autocmds.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  colorschemes.dracula.enable = true;

  editorconfig.enable = true;

  extraConfigVim = ''
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
  '';
}
