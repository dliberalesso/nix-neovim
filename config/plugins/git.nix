{pkgs, ...}: {
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    {
      pkg = mini-nvim;
      name = "mini-diff";

      event = ["BufReadPre" "BufNewFile"];

      config = true;
      main = "mini.diff";

      opts.view = {
        style = "sign";
        signs = {
          add = "▎";
          change = "▎";
          delete = "";
          topdelete = "";
          changedelete = "▎";
          untracked = "▎";
        };
      };
    }
  ];
}
