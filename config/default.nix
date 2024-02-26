{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
    ./options.nix
  ];

  colorschemes.dracula.enable = true;

  editorconfig.enable = true;

  # Sync clipboard between OS and Neovim
  clipboard.register = "unnamedplus";

  plugins = {
    lualine.enable = true;
    treesitter.enable = true;
  };

  extraConfigVim = ''
    aunmenu PopUp.How-to\ disable\ mouse
    aunmenu PopUp.-1-
  '';
}
