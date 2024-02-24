{
  # Import all your configuration modules here
  imports = [
    ./bufferline.nix
    ./options.nix
  ];

  editorconfig.enable = true;

  plugins = {
    lualine.enable = true;
    treesitter.enable = true;
  };

  colorschemes.dracula.enable = true;  
}
