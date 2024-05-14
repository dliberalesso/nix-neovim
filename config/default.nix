{ pkgs, ... }: {
  imports = [
    ./disable_plugins.nix
    ./highlight_yank.nix
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];

  editorconfig.enable = true;

  extraConfigVim = /* vim */ ''
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
  '';
}
