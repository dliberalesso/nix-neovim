---@type LazySpec[]
return {
  {
    -- "AstroNvim/astrocore",
    dir = vim.env.LAZY_ROOT_DIR .. "/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      local astro = require("astrocore")
      maps.n["<Leader>t"] = vim.tbl_get(opts, "_map_sections", "t")
      maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
      local lazygit = {
        callback = function(direction)
          local worktree = astro.file_worktree()
          local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir) or ""
          astro.toggle_term_cmd({ cmd = "lazygit " .. flags, direction = direction })
        end,
        desc = "ToggleTerm lazygit",
      }
      maps.n["<Leader>gg"] = { lazygit.callback, desc = lazygit.desc .. " (float)" }
      maps.n["<Leader>tl"] = { function() lazygit.callback("tab") end, desc = lazygit.desc .. " (tab)" }
      -- if vim.fn.executable("node") == 1 then
      --   maps.n["<Leader>tn"] = { function() astro.toggle_term_cmd("node") end, desc = "ToggleTerm node" }
      -- end
      -- local gdu = vim.fn.has("mac") == 1 and "gdu-go" or "gdu"
      -- if vim.fn.has("win32") == 1 and vim.fn.executable(gdu) ~= 1 then gdu = "gdu_windows_amd64.exe" end
      -- if vim.fn.executable(gdu) == 1 then
      --   maps.n["<Leader>tu"] = { function() astro.toggle_term_cmd(gdu) end, desc = "ToggleTerm gdu" }
      -- end
      maps.n["<Leader>tb"] = { function() astro.toggle_term_cmd("btm") end, desc = "ToggleTerm btm" }
      -- local python = vim.fn.executable("python") == 1 and "python" or vim.fn.executable("python3") == 1 and "python3"
      -- if python then
      --   maps.n["<Leader>tp"] = { function() astro.toggle_term_cmd(python) end, desc = "ToggleTerm python" }
      -- end
      maps.n["<Leader>tf"] = { "<Cmd>ToggleTerm direction=float<CR>", desc = "ToggleTerm float" }
      maps.n["<Leader>th"] =
        { "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", desc = "ToggleTerm horizontal split" }
      maps.n["<Leader>tv"] = { "<Cmd>ToggleTerm size=80 direction=vertical<CR>", desc = "ToggleTerm vertical split" }
      maps.n["<F7>"] = { '<Cmd>execute v:count . "ToggleTerm"<CR>', desc = "Toggle terminal" }
      maps.t["<F7>"] = { "<Cmd>ToggleTerm<CR>", desc = "Toggle terminal" }
      maps.i["<F7>"] = { "<Esc><Cmd>ToggleTerm<CR>", desc = "Toggle terminl" }
    end,
  },
  {
    -- "akinsho/toggleterm.nvim",
    dir = vim.env.LAZY_ROOT_DIR .. "/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      highlights = {
        Normal = { link = "Normal" },
        NormalNC = { link = "NormalNC" },
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
        StatusLine = { link = "StatusLine" },
        StatusLineNC = { link = "StatusLineNC" },
        WinBar = { link = "WinBar" },
        WinBarNC = { link = "WinBarNC" },
      },
      size = 10,
      ---@param t Terminal
      on_create = function(t)
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.signcolumn = "no"
        if t.hidden then
          local toggle = function() t:toggle() end
          vim.keymap.set({ "n", "t", "i" }, "<C-'>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
          vim.keymap.set({ "n", "t", "i" }, "<F7>", toggle, { desc = "Toggle terminal", buffer = t.bufnr })
        end
      end,
      shading_factor = 2,
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },
}
