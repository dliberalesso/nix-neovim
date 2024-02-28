{
  autoGroups = {
    highlight-yank = {
      clear = true;
    };
  };

  autoCmd = [
    # Highlight when yanking (copying) text
    #  See `:help vim.highlight.on_yank()`
    {
      event = ["TextYankPost"];
      desc = "Highlight when yanking (copying) text";
      group = "highlight-yank";
      callback.__raw = "function() vim.highlight.on_yank() end";
    }
  ];
}
