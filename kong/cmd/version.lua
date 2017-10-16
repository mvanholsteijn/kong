local meta      = require "kong.meta"
local utils     = require "kong.tools.utils"
local constants = require "kong.constants"

local lapp = [[
Usage: kong version [OPTIONS]

Print Kong's version. With the -a option, will print
the version of all underlying dependencies.

Options:
 -a,--all         get version of all dependencies
]]

local str = [[
Kong Core: %s

Plugins:
%s

Dependancies:
ngx_lua: %s
nginx: %s
Lua: %s]]


local function plugins_vers()
  local plugins_vers = {}

  for p, _ in pairs(constants.PLUGINS_AVAILABLE) do
    local _, handler = utils.load_module_if_exists("kong.plugins." ..
                                                    p .. ".handler")

    local v = handler.VERSION

    if not v then
      error("Could not load version info for plugin " .. p)
    end

    table.insert(plugins_vers, p .. ": " .. v)
  end

  -- cheat on the sort, we'll end up sort by name before version :p
  table.sort(plugins_vers)

  return table.concat(plugins_vers, "\n")
end


local function execute(args)
  if args.all then
    print(string.format(str,
      meta._VERSION,
      plugins_vers(),
      ngx.config.ngx_lua_version,
      ngx.config.nginx_version,
      jit and jit.version or _VERSION
    ))
  else
    print(meta._VERSION)
  end
end

return {
  lapp = lapp,
  execute = execute
}
