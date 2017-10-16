local pl_stringx = require "pl.stringx"
local helpers = require "spec.helpers"
local meta = require "kong.meta"

describe("kong version", function()
  it("outputs Kong version", function()
    local _, _, stdout = assert(helpers.kong_exec("version"))
    assert.equal(meta._VERSION, pl_stringx.strip(stdout))
  end)
  it("--all outputs all plugins and deps versions", function()
    local _, _, stdout = assert(helpers.kong_exec("version -a"))
    assert.matches([[
Kong Core: ]] .. meta._VERSION .. [[


Plugins:]], stdout)

    assert.matches([[

Dependancies:
ngx_lua: %d+
nginx: %d+
Lua: .*
]], stdout)
  end)
end)
