local M = {}

---@param core_module string
---@param rest table
---@return LazySpec
function M.core_spec(core_module, rest)
  M.dir = M.dir or vim.fn.stdpath("config") --[[@as string]]
  local name = "core." .. core_module

  return vim.tbl_extend("force", {
    name = name,
    main = name,
    dir = M.dir,
    config = true,
  }, rest)
end

-- A helper function to wrap a module function to require a plugin before running
---@param plugin string The plugin to call `require("lazy").load` with
---@param module table The system module where the functions live (e.g. `vim.ui`)
---@param funcs string|string[] The functions to wrap in the given module (e.g. `"ui", "select"`)
function M.load_plugin_with_func(plugin, module, funcs)
  if type(funcs) == "string" then
    funcs = { funcs }
  end
  for _, func in ipairs(funcs) do
    local old_func = module[func]
    module[func] = function(...)
      module[func] = old_func
      require("lazy").load({ plugins = { plugin } })
      module[func](...)
    end
  end
end

-- Get an empty table of mappings with a key for each map mode
---@return table<string,table> # a table with entries for each map mode
function M.empty_map_table()
  local maps = {}

  -- stylua: ignore
  for _, mode in ipairs {
    "", "n", "v", "x", "s", "o", "!", "i", "l", "c", "t", "ia", "ca", "!a"
  } do
    maps[mode] = {}
  end

  return maps
end

-- Get a plugin spec from lazy
---@param plugin string The plugin to search for
---@return LazyPlugin? available # The found plugin spec from Lazy
function M.get_plugin(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

-- Resolve the options table for a given plugin with lazy
---@param plugin string The plugin to search for
---@return table opts # The plugin options
function M.plugin_opts(plugin)
  local spec = M.get_plugin(plugin)
  return spec and require("lazy.core.plugin").values(spec, "opts") or {}
end

-- Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)
---@param path string The path of the file to open with the system opener
function M.system_open(path)
  if not path then
    path = vim.fn.expand("<cfile>")
  elseif not path:match("%w+:") then
    path = vim.fn.expand(path)
  end

  return vim.ui.open(path)
end

return M
