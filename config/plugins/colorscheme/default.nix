{
  imports = [
    ./catppuccin.nix
    ./tokyonight.nix
  ];

  config.extraConfigLua = /* lua */ ''
    vim.cmd.colorscheme("catppuccin")
  '';
}
