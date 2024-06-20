local M = {}

function M.setup(maps)
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

  require("core.utils").set_mappings(maps)
end

return M
