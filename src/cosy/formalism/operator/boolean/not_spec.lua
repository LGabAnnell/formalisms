--These lines are required to correctly run tests.
require "busted.runner" ()

local Layer   = require "layeredata"
local path    = "cosy/formalism/operator/boolean.not"

describe ("Formalism not", function ()
  it ("can be loaded", function ()
    local _ = Layer.require (path)
  end)
end)