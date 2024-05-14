{ config, pkgs, ... }:
let
  inherit (config) utils;
in
{
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = lazygit-nvim;

      dependencies = [
        plenary-nvim
      ];

      cmd = [
        "LazyGit"
        "LazyGitConfig"
        "LazyGitCurrentFile"
        "LazyGitFilter"
        "LazyGitFilterCurrentFile"
      ];

      keys = {
        __raw = ''
          { { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Lazy[G]it" } }
        '';
      };
    }
  ];
}
