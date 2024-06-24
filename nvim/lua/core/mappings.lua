local M = {}

function M.setup(maps)
  -- Standard Operations
  maps.n["j"] = { "v:count == 0 ? 'gj' : 'j'", expr = true, silent = true, desc = "Move cursor down" }
  maps.x["j"] = maps.n["j"]
  maps.n["k"] = { "v:count == 0 ? 'gk' : 'k'", expr = true, silent = true, desc = "Move cursor up" }
  maps.x["k"] = maps.n["k"]
  maps.n["<Leader>w"] = { "<Cmd>w<CR>", desc = "Save" }
  maps.n["<Leader>q"] = { "<Cmd>confirm q<CR>", desc = "Quit Window" }
  maps.n["<Leader>Q"] = { "<Cmd>confirm qall<CR>", desc = "Exit AstroNvim" }
  maps.n["<Leader>n"] = { "<Cmd>enew<CR>", desc = "New File" }
  maps.n["|"] = { "<Cmd>vsplit<CR>", desc = "Vertical Split" }
  maps.n["\\"] = { "<Cmd>split<CR>", desc = "Horizontal Split" }

  -- TODO: remove deprecated method check after dropping support for neovim v0.9
  -- if not vim.ui.open then
  --   local gx_desc = "Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)"
  --   maps.n["gx"] = { function() require("core.utils").system_open(vim.fn.expand "<cfile>") end, desc = gx_desc }
  --   maps.x["gx"] = {
  --     function()
  --       local lines = vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", { type = vim.fn.mode() })
  --       require("core.utils").system_open(table.concat(vim.tbl_map(vim.trim, lines)))
  --     end,
  --     desc = gx_desc,
  --   }
  -- end

  -- Plugins
  maps.n["<Leader>pp"] = {
    function()
      require("lazy").profile()
    end,
    desc = "Plugins Profile",
  }
  maps.n["<Leader>ps"] = {
    function()
      require("lazy").home()
    end,
    desc = "Plugins Status",
  }

  -- Manage Buffers
  -- maps.n["<Leader>c"] = { function() require("astrocore.buffer").close() end, desc = "Close buffer" }
  -- maps.n["<Leader>C"] = { function() require("astrocore.buffer").close(0, true) end, desc = "Force close buffer" }
  -- maps.n["]b"] = {
  --   function() require("astrocore.buffer").nav(vim.v.count1) end,
  --   desc = "Next buffer",
  -- }
  -- maps.n["[b"] = {
  --   function() require("astrocore.buffer").nav(-vim.v.count1) end,
  --   desc = "Previous buffer",
  -- }
  -- maps.n[">b"] = {
  --   function() require("astrocore.buffer").move(vim.v.count1) end,
  --   desc = "Move buffer tab right",
  -- }
  -- maps.n["<b"] = {
  --   function() require("astrocore.buffer").move(-vim.v.count1) end,
  --   desc = "Move buffer tab left",
  -- }
  -- maps.n["<Leader>bc"] =
  --   { function() require("astrocore.buffer").close_all(true) end, desc = "Close all buffers except current" }
  -- maps.n["<Leader>bC"] = { function() require("astrocore.buffer").close_all() end, desc = "Close all buffers" }
  -- maps.n["<Leader>bl"] =
  --   { function() require("astrocore.buffer").close_left() end, desc = "Close all buffers to the left" }
  -- maps.n["<Leader>bp"] = { function() require("astrocore.buffer").prev() end, desc = "Previous buffer" }
  -- maps.n["<Leader>br"] =
  --   { function() require("astrocore.buffer").close_right() end, desc = "Close all buffers to the right" }
  -- maps.n["<Leader>bs"] = vim.tbl_get(sections, "bs")
  -- maps.n["<Leader>bse"] = { function() require("astrocore.buffer").sort "extension" end, desc = "By extension" }
  -- maps.n["<Leader>bsr"] = { function() require("astrocore.buffer").sort "unique_path" end, desc = "By relative path" }
  -- maps.n["<Leader>bsp"] = { function() require("astrocore.buffer").sort "full_path" end, desc = "By full path" }
  -- maps.n["<Leader>bsi"] = { function() require("astrocore.buffer").sort "bufnr" end, desc = "By buffer number" }
  -- maps.n["<Leader>bsm"] = { function() require("astrocore.buffer").sort "modified" end, desc = "By modification" }

  -- LSP
  maps.n["<Leader>ld"] = {
    function()
      vim.diagnostic.open_float()
    end,
    desc = "Hover diagnostics",
  }

  -- Navigate tabs
  maps.n["]t"] = {
    function()
      vim.cmd.tabnext()
    end,
    desc = "Next tab",
  }
  maps.n["[t"] = {
    function()
      vim.cmd.tabprevious()
    end,
    desc = "Previous tab",
  }

  -- Split navigation
  maps.n["<C-H>"] = { "<C-w>h", desc = "Move to left split" }
  maps.n["<C-J>"] = { "<C-w>j", desc = "Move to below split" }
  maps.n["<C-K>"] = { "<C-w>k", desc = "Move to above split" }
  maps.n["<C-L>"] = { "<C-w>l", desc = "Move to right split" }
  maps.n["<C-Up>"] = { "<Cmd>resize -2<CR>", desc = "Resize split up" }
  maps.n["<C-Down>"] = { "<Cmd>resize +2<CR>", desc = "Resize split down" }
  maps.n["<C-Left>"] = { "<Cmd>vertical resize -2<CR>", desc = "Resize split left" }
  maps.n["<C-Right>"] = { "<Cmd>vertical resize +2<CR>", desc = "Resize split right" }

  -- Stay in indent mode
  maps.v["<S-Tab>"] = { "<gv", desc = "Unindent line" }
  maps.v["<Tab>"] = { ">gv", desc = "Indent line" }

  -- Improved Terminal Navigation
  maps.t["<C-H>"] = { "<Cmd>wincmd h<CR>", desc = "Terminal left window navigation" }
  maps.t["<C-J>"] = { "<Cmd>wincmd j<CR>", desc = "Terminal down window navigation" }
  maps.t["<C-K>"] = { "<Cmd>wincmd k<CR>", desc = "Terminal up window navigation" }
  maps.t["<C-L>"] = { "<Cmd>wincmd l<CR>", desc = "Terminal right window navigation" }

  -- UI/UX
  -- maps.n["<Leader>uA"] = { function() require("astrocore.toggles").autochdir() end, desc = "Toggle rooter autochdir" }
  -- maps.n["<Leader>ub"] = { function() require("astrocore.toggles").background() end, desc = "Toggle background" }
  -- maps.n["<Leader>ud"] = { function() require("astrocore.toggles").diagnostics() end, desc = "Toggle diagnostics" }
  -- maps.n["<Leader>ug"] = { function() require("astrocore.toggles").signcolumn() end, desc = "Toggle signcolumn" }
  -- maps.n["<Leader>u>"] = { function() require("astrocore.toggles").foldcolumn() end, desc = "Toggle foldcolumn" }
  -- maps.n["<Leader>ui"] = { function() require("astrocore.toggles").indent() end, desc = "Change indent setting" }
  -- maps.n["<Leader>ul"] = { function() require("astrocore.toggles").statusline() end, desc = "Toggle statusline" }
  -- maps.n["<Leader>un"] = { function() require("astrocore.toggles").number() end, desc = "Change line numbering" }
  -- maps.n["<Leader>uN"] =
  --   { function() require("astrocore.toggles").notifications() end, desc = "Toggle Notifications" }
  -- maps.n["<Leader>up"] = { function() require("astrocore.toggles").paste() end, desc = "Toggle paste mode" }
  -- maps.n["<Leader>us"] = { function() require("astrocore.toggles").spell() end, desc = "Toggle spellcheck" }
  -- maps.n["<Leader>uS"] = { function() require("astrocore.toggles").conceal() end, desc = "Toggle conceal" }
  -- maps.n["<Leader>ut"] = { function() require("astrocore.toggles").tabline() end, desc = "Toggle tabline" }
  -- maps.n["<Leader>uu"] = { function() require("astrocore.toggles").url_match() end, desc = "Toggle URL highlight" }
  -- maps.n["<Leader>uw"] = { function() require("astrocore.toggles").wrap() end, desc = "Toggle wrap" }
  -- maps.n["<Leader>uy"] =
  --   { function() require("astrocore.toggles").buffer_syntax() end, desc = "Toggle syntax highlight" }

  -- Set a table of mappings
  for mode, keymaps in pairs(maps) do -- iterate over the first keys for each mode
    for keymap, options in pairs(keymaps) do -- iterate over each keybinding set in the current mode
      if options then -- build the options for the command accordingly
        local cmd = options
        local keymap_opts = base or {}
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
          keymap_opts[1] = nil
        end
        vim.keymap.set(mode, keymap, cmd, keymap_opts)
      end
    end
  end
end

return M
