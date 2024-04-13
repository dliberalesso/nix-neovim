{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./devicons.nix
    ./gitsigns.nix
    ./incline.nix
    ./lazygit.nix
    ./lualine.nix
    ./telescope.nix
    ./which-key.nix
  ];

  plugins = {
    comment.enable = true;
    indent-o-matic.enable = true;
    treesitter.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [];
}
