-- These lines are required to correctly run tests.
require "busted.runner" ()

local Layer = require "cosy.formalism.layer"

describe ("Formalism literal.literal", function ()

  it ("can be loaded", function ()
    local _ = Layer.require "cosy/formalism/literal.bool"
  end)

  describe ("with type information", function ()

    it ("forbids a different type", function ()
      local bool = Layer.require "cosy/formalism/literal.bool"  
      local meta    =  Layer.key.meta
      local refines =  Layer.key.refines
      local layer      = Layer.new {
        name = "layer",
        data = {
          [Layer.key.refines] = { bool },
          value = true,  
        },
      }
      Layer.Proxy.check (layer)
      assert.is_nil (Layer.messages (layer) ())
    end)
	end)

end)