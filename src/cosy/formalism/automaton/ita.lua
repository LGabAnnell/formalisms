-- Interrupt Timed Automata
-- ========================
--
-- An interrupt timed automaton is a tuple (Q, Σ, q0, F, X, λ, δ) where:
--
-- * Q is a set of vertices called states. Each q in Q has a level l. There are as many levels as there are clocks.
-- * Σ is a finite alphabet, describe [here](./alphabet.html)
-- * q0 is the start state, q0 is in Q
-- * F is a subset of Q, they are the accept states
-- * X is a set of interrupt clocks.
-- * λ associate a state with is level and x[λ(q)] is the active clocks. The others are stopped.
-- * δ is a set of labelled edges called transition. this edges are labelled by:
--      * a guard, it's a conjunction of polynomial constraints
--      * a symbol of Σ
--      * an update, it's the new valuation of a clock calculate by a polynomial of the others.
--
-- See [here](http://arxiv.org/abs/1504.04541)

return function (Layer, ita, ref)

  local defaults = Layer.key.defaults
  local meta     = Layer.key.meta
  local refines  = Layer.key.refines

  local record     = Layer.require "cosy/formalism/data.record"
  local collection = Layer.require "cosy/formalism/data.collection"
  local automaton  = Layer.require "cosy/formalism/automaton"

  ita [refines] = {
    automaton,
  }

  ita.analogs = {
    [refines] = {
      collection,
    },
    [meta] = {
      record = {
        value_type = ref [meta].analog_type,
      },
    },
    [defaults] = {
      ref [meta].analog_type,
    },
  }

  ita.levels = {
    [refines] = {
      collection,
    },
    [meta] = {
      record = {
        value_type = ref [meta].level_type,
      }
    },
    [defaults] = {
      ref [meta].level_type,
    },
  }

  ita [meta].analog_type = {
    [refines] = {
      record,
    },
    [meta] = {
      record = {
        active_level = {
          value_type      = ref [meta].level_type,
          value_container = ref.levels,
        },
      }
    },
  }

  ita [meta].level_type = {}

  ita [meta].guard_type = {
    [refines] = {
      record,
    },
    [meta] = {
      record = {
        comparison = {
          value_type      = "string",
          value_container = { "<", "<=", "=", ">=", ">" },
        },
      },
    }
  }

  ita [meta].polynomial = {
    [refines] = {
      collection,
    },
    [meta] = {
      value_type = ref [meta].polynomial_type,
    },
    [defaults] = {
      ref [meta].polynomial_type,
    },
  }

  ita [meta].update_type = {
    [refines] = {
      collection,
    },
    [meta] = {
      collection = {
        value_type    = ref [meta].polynomial_type,
        key_type      = ref [meta].analog_type,
        key_container = ref.analogs,
      }
    },
  }

  ita [meta].edge_type = {
    update = {
      [refines] = {
        ref [meta].update_type,
      },
    },

    guard = {
      [refines] = {
        ref [meta].guard_type
      },
    },
  }

  ita [meta].vertex_type  = {
    [meta] = {
      record = {
        level = {
          value_type      = ref [meta].level_type,
          value_container = ref.levels,
        },
      },
    },
  }

  ita [meta].initial_state_type = {
    analogs_init = {
      [refines] = {
        collection,
      },
      [meta] = {
        collection = {
          value_type    = "number",
          key_type      = ref [meta].analog_type,
          key_container = ref.analogs,
        },
      },
    },
  }

end
