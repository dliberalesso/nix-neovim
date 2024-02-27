{
  keymaps = [
    {
      # Clear highlight on search when pressing <Esc> in normal mode
      # vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }
  ];
}