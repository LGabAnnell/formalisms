if #setmetatable ({}, { __len = function () return 1 end }) ~= 1 then
  require "compat52"
end

-- These lines are required to correctly run tests.
require "busted.runner" ()

describe ("Formalism data.enumeration", function ()

  it ("can be loaded", function ()
    local Layer = require "layeredata"
    local _     = Layer.require "cosy/formalism/data.enumeration"
  end)

  it ("detects wrongly typed elements (primitive)", function ()
    local Layer       = require "layeredata"
    local enumeration = Layer.require "cosy/formalism/data.enumeration"
    local layer       = Layer.new {}
    layer [Layer.key.refines] = { enumeration }
    layer [Layer.key.meta   ] = {
      [enumeration] = {
        symbol_type = "string"
      },
    }
    layer.key = 3
    Layer.Proxy.check_all (layer)
    assert.is_not_nil (next (Layer.messages))
  end)

  it ("detects correctly typed elements (primitive)", function ()
    local Layer       = require "layeredata"
    local enumeration = Layer.require "cosy/formalism/data.enumeration"
    local layer       = Layer.new {}
    layer [Layer.key.refines] = { enumeration }
    layer [Layer.key.meta   ] = {
      [enumeration] = {
        symbol_type = "string"
      },
    }
    layer.key = "value"
    Layer.Proxy.check_all (layer)
    assert.is_nil (next (Layer.messages))
  end)

  it ("detects wrongly typed elements (proxy)", function ()
    local Layer       = require "layeredata"
    local enumeration = Layer.require "cosy/formalism/data.enumeration"
    local layer, ref  = Layer.new {}
    layer [Layer.key.refines] = { enumeration }
    layer [Layer.key.meta   ] = {
      t = {},
      [enumeration] = {
        symbol_type = ref [Layer.key.meta].t,
      }
    }
    layer.key = true
    Layer.Proxy.check_all (layer)
    assert.is_not_nil (next (Layer.messages))
  end)

  it ("detects correctly typed elements (proxy)", function ()
    local Layer       = require "layeredata"
    local enumeration = Layer.require "cosy/formalism/data.enumeration"
    local layer, ref  = Layer.new {}
    layer [Layer.key.refines] = { enumeration }
    layer [Layer.key.meta   ] = {
      t = {},
      [enumeration] = {
        symbol_type = ref [Layer.key.meta].t,
      }
    }
    layer.key = {
      [Layer.key.refines] = { ref [Layer.key.meta].t }
    }
    Layer.Proxy.check_all (layer)
    assert.is_nil (next (Layer.messages))
  end)

  it ("sets the value type by default (proxy)", function ()
    local Layer       = require "layeredata"
    local enumeration = Layer.require "cosy/formalism/data.enumeration"
    local layer, ref  = Layer.new {}
    layer [Layer.key.refines] = { enumeration }
    layer [Layer.key.meta   ] = {
      t = { a = 1 },
      [enumeration] = {
        symbol_type = ref [Layer.key.meta].t,
      }
    }
    layer.key = {}
    Layer.Proxy.check_all (layer)
    assert.is_nil (next (Layer.messages))
  end)

end)
