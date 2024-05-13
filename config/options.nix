{
  config = {
    globals = {
      # Set <space> as the leader key
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      # A lot of plugins depends on hidden true
      hidden = true;

      # Make line numbers default
      number = true;
      relativenumber = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Show which line your cursor is on
      cursorline = true;

      # Statusline
      laststatus = 3;

      # Command line height
      # cmdheight = 2;
      cmdheight = 0;

      # Don't show the mode, since it's already in status line
      showmode = false;

      # Hide tabline
      showtabline = 0;

      # Tab settings
      tabstop = 4;
      softtabstop = 4;
      expandtab = true;
      shiftwidth = 4;

      # Enable smart indenting
      smartindent = true;
      breakindent = true;

      # No wrap
      wrap = false;

      # Minimal number of screen lines/columns to keep around the cursor.
      scrolloff = 10;
      sidescrolloff = 10;

      # Set highlight on search
      hlsearch = false;
      incsearch = true;

      # Preview substitutions live
      inccommand = "split";

      # Case-insensitive searching UNLESS \C or capital in search
      ignorecase = true;
      smartcase = true;

      # Better undo history
      swapfile = false;
      backup = false;
      undodir = {__raw = "os.getenv('HOME') .. '/.cache/nvim/undodir'";};
      undofile = true;
      shada = ["'10" "<0" "s10" "h"];

      # Decrease update time
      updatetime = 250;
      timeoutlen = 300;

      # Configure how new splits should be opened
      splitright = true;
      splitbelow = true;

      # Sets how neovim will display certain whitespace in the editor
      list = true;
      listchars = "tab:» ,space: ,trail:•,extends:→,precedes:←,nbsp:␣";
    };
  };
}
