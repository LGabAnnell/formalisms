if #setmetatable ({}, { __len = function () return 1 end }) ~= 1 then
  require "compat52"
end

-- These lines are required to correctly run tests.
require "busted.runner" ()

describe ("Formalism graph", function ()

  it ("can be loaded", function ()
    local Layer = require "layeredata"
    local _     = Layer.require "cosy/formalism/graph"
  end)

  describe ("vertices", function ()

    it ("can be created", function ()
      local Layer = require "layeredata"
      local graph = Layer.require "cosy/formalism/graph"
      local layer = Layer.new {}
      layer [Layer.key.refines] = { graph }
      layer.vertices.a = {}
      layer.vertices.b = {}
      Layer.Proxy.check_all (layer)
      assert.is_nil  (next (Layer.messages))
      assert.is_true (layer [Layer.key.meta].vertex_type <= layer.vertices.a)
      assert.is_true (layer [Layer.key.meta].vertex_type <= layer.vertices.b)
    end)

    it ("refine vertex_type", function ()
      local Layer      = require "layeredata"
      local graph      = Layer.require "cosy/formalism/graph"
      local layer, ref = Layer.new {}
      layer [Layer.key.refines] = { graph }
      layer [Layer.key.meta   ] = {
        t = {},
      }
      layer.vertices.a = {
        [Layer.key.refines] = { ref [Layer.key.meta].t }
      }
      assert.is_true (layer [Layer.key.meta].t <= layer.vertices.a)
      assert.is_true (layer [Layer.key.meta].vertex_type <= layer.vertices.a)
    end)

    it ("are iterable", function ()
      local Layer = require "layeredata"
      local graph = Layer.require "cosy/formalism/graph"
      local layer = Layer.new {}
      layer [Layer.key.refines] = { graph }
      layer.vertices.a = {}
      layer.vertices.b = {}
      local found = {}
      for k in pairs (layer.vertices) do
        found [k] = true
      end
      assert.are.same (found, {
        a = true,
        b = true,
      })
    end)

  end)

  describe ("edges", function ()

    it ("can be created", function ()
      local Layer      = require "layeredata"
      local graph      = Layer.require "cosy/formalism/graph"
      local layer, ref = Layer.new {}
      layer [Layer.key.refines] = { graph }
      layer.vertices.a = {}
      layer.vertices.b = {}
      layer.edges.ab   = {
        arrows = {
          a = { vertex = ref.vertices.a },
          b = { vertex = ref.vertices.b },
        }
      }
      Layer.Proxy.check_all (layer)
      assert.is_nil (next (Layer.messages))
      assert.is_true (layer [Layer.key.meta].edge_type <= layer.edges.ab)
      assert.is_true (layer.edges.ab [Layer.key.meta].arrow_type <= layer.edges.ab.arrows.a)
      assert.is_true (layer.edges.ab [Layer.key.meta].arrow_type <= layer.edges.ab.arrows.b)
    end)

    it ("must contain a vertex field", function ()
      local Layer = require "layeredata"
      local graph = Layer.require "cosy/formalism/graph"
      local layer = Layer.new {}
      layer [Layer.key.refines] = { graph }
      layer.vertices.a = {}
      layer.vertices.b = {}
      layer.edges.ab   = {
        arrows = {
          a = {},
        }
      }
      Layer.Proxy.check_all (layer)
      assert.is_not_nil (Layer.messages [layer.edges.ab.arrows.a])
    end)

    it ("must contain a vertex field from the vertices container", function ()
      local Layer      = require "layeredata"
      local graph      = Layer.require "cosy/formalism/graph"
      local layer, ref = Layer.new {}
      layer [Layer.key.refines] = { graph }
      layer.vertices.a = {}
      layer.vertices.b = {}
      layer.edges.ab   = {
        arrows = {
          a = { vertex = ref.edges.ab },
        }
      }
      Layer.Proxy.check_all (layer)
      assert.is_not_nil (Layer.messages [layer.edges.ab.arrows.a])
    end)

  end)


end)
