local Layer             = require "layeredata"
local hyper_multi_graph = require "formalisms.hyper_multi_graph"
local layer             = Layer.new {
  name = "hyper & multi graph instance"
}
local _                 = Layer.reference "HMGT_model"
local root              = Layer.reference (false)

layer.__refines__ = {
  hyper_multi_graph,
}

layer.model = {
  __label__ = "HMGT_model",

  __refines__ = {
    root.__meta__.hyper_multi_graph_type,
  },

  vertices = {
    n1 = {},
    n2 = {},
    n3 = {},
  },

  edges = {
    e1 = {
      arrows = {
        { vertex = _.vertices.n1 },
        { vertex = _.vertices.n2 },
        { vertex = _.vertices.n3 },
      },
    },

    e2 = {
      arrows = {
        { vertex = _.vertices.n1 },
        { vertex = _.vertices.n2 },
      },
    },
  },
}

do
  print(Layer.dump(Layer.flatten(layer)))
end
