local jwt_schema = require "kong.plugins.jwt.schema"

describe("Plugin: jwt (schema)", function()
   local ok, res, _

   ok, _ = jwt_schema.self_check(nil, {maximum_expiration = -1}, nil, true)
   assert.is_true(ok) 

   ok, res = jwt_schema.self_check(nil, {maximum_expiration = 300}, nil, true)
   assert.is_false(ok) 
   assert.is_equals(res.message, "when you specify maximum_expiration, 'exp' must be in claims_to_verify") 

   ok = jwt_schema.self_check(nil, {maximum_expiration = 300, claims_to_verify = {}}, nil, true)
   assert.is_false(ok) 
   assert.is_equals(res.message, "when you specify maximum_expiration, 'exp' must be in claims_to_verify") 

   ok = jwt_schema.self_check(nil, {maximum_expiration = 300, claims_to_verify = {"exp"}}, nil, true)
   assert.is_true(ok) 

   ok = jwt_schema.self_check(nil, {maximum_expiration = -1, claims_to_verify = {"iss", "exp", "nbf"}}, nil, true)
   assert.is_true(ok) 
end)
