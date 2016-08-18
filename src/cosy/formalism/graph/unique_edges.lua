-- Graph with unique edges
-- =======================
--
-- This formalism corresponds to the removal of the multigraph part of graphs.
-- There are no two edges linking the same vertices.
--
-- For more information see [here](https://en.wikipedia.org/wiki/Multigraph)

return function (Layer, unique_edges)

  local checks   = Layer.key.checks
  local refines  = Layer.key.refines

  local graph = Layer.require "cosy/formalism/graph"

  unique_edges [refines] = {
    graph,
  }

  -- We add a check function to the `edges` container, that iterates through it,
  -- and verifies that there are no two edges with the same vertices.
  --
  -- FIXME: this is very inefficient, as it performs iteration on the whole
  -- collection each time it is modified.
  unique_edges.edges [checks] = {
    ["cosy/formalism/graph.unique-edges"] = function (proxy)
      local edges = {}
      for _, edge in pairs (proxy.edges) do
        local vertices = {}
        for _, arrow in pairs (edge.arrows) do
          vertices [arrow.vertex] = true
        end
        edges [edge] = vertices
      end
      for edge_l, vertices_l in pairs (edges) do
        for edge_r, vertices_r in pairs (edges) do
          if vertices_l ~= vertices_r then
            local found_l, found_r = false, false
            for vertex in pairs (vertices_l) do
              if vertices_r [vertex] then
                found_l = true
                break
              end
            end
            for vertex in pairs (vertices_r) do
              if vertices_l [vertex] then
                found_r = true
                break
              end
            end
            if found_l and found_r then
              Layer.coroutine.yield ("cosy/formalism/graph.unique-edges.illegal", {
                proxy     = proxy,
                container = proxy.edges,
                edges     = { edge_l, edge_r },
              })
            end
          end
        end
      end
    end,
  }

  return unique_edges

end
