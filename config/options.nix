{
  config = {
    globals = {
      # Set <space> as the leader key
      mapleader = " ";
      maplocalleader = " ";
    };

    options = {
      # Make line numbers default
      number = true;
      relativenumber = true;

      # Don't show the mode, since it's already in status line
      showmode = false;

      # Enable break indent
      breakindent = true;

      # Save undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or capital in search
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease update time
      updatetime = 250;
      timeoutlen = 300;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how neovim will display certain whitespace in the editor
      list = true;
      listchars = "tab:» ,lead:·,space: ,trail:•,extends:→,precedes:←,nbsp:␣";

      # Preview substitutions live
      inccommand = "split";

      # Show which line your cursor is on
      cursorline = true;

      # Minimal number of screen lines to keep above and below the cursor.
      scrolloff = 10;

      # Set highlight on search
      hlsearch = true;
    };
  };
}