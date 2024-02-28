{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./devicons.nix
    ./gitsigns.nix
    ./lualine.nix
    ./telescope.nix
    ./which-key.nix
  ];

  plugins = {
    comment-nvim.enable = true;
    bufferline.enable = true;
    indent-o-matic.enable = true;
    treesitter.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [];
}
