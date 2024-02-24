{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
  ];

  config = {
    options = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2;        # Tab width should be 2
    };
  };

  editorconfig.enable = true;

  plugins = {
    lualine.enable = true;
    treesitter.enable = true;
  };

  colorschemes.dracula.enable = true;  
}
