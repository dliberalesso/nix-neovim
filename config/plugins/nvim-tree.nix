{
  plugins.nvim-tree = {
    enable = true;

    disableNetrw = true;

    filters.custom = [
      "^.git$"
    ];
  };
}
