-- Record
-- ======
--
-- A record is a table where some keys are mandatory, and their corresponding
-- values are typed.
--
-- To create a new record type, refine this formalism and add the fields
-- descriptions in its `[meta][record]` table.
--
-- `[meta][record]` is a mapping from keys to their require value type,
-- that can be either the string representation of the Lua type name
-- (for instance "boolean", "number", "string"), or a reference to the expected
-- parent type.

return function (Layer, record)

  local checks   = Layer.key.checks
  local meta     = Layer.key.meta

  local check_type      = Layer.require "type.check"          .apply
  local check_container = Layer.require "data.check_container".apply

  local prefix = "data.record"

  local function has_meta (proxy)
    for _, key in Layer.Proxy.keys (proxy) do
      if key == meta then
        return true
      end
    end
    return false
  end

  record [meta] = {
    [record] = {
      -- key = {
      --   value_type      = false,
      --   value_container = false,
      -- }
    },
  }

  record [checks] = {}

  record [checks] [prefix .. ".value_type"] = function (proxy)
    if has_meta (proxy) then
      return
    end
    for key, description in Layer.pairs (proxy [meta][record]) do
      if  getmetatable (description) == Layer.Proxy
      and description.value_type then
        if  type (description.value_type) ~= "string"
        and getmetatable (description.value_type) ~= Layer.Proxy then
          Layer.coroutine.yield (prefix .. ".value_type.invalid", {
            proxy = proxy,
            key   = key,
            used  = description.value_type,
          })
        else
          check_type (proxy [key], description.value_type, {
            proxy  = proxy,
            key    = key,
            prefix = prefix .. ".value_type",
          })
        end
      end
    end
  end

  record [checks] [prefix .. ".value_container"] = function (proxy)
    if has_meta (proxy) then
      return
    end
    for key, description in Layer.pairs (proxy [meta] [record]) do
      if  getmetatable (description) == Layer.Proxy
      and description.value_container then
        if  getmetatable (description.value_container) ~= Layer.Proxy then
          Layer.coroutine.yield (prefix .. ".value_container.invalid", {
            proxy = proxy,
            key   = key,
            used  = description.value_container,
          })
        else
          check_container (proxy [key], description.value_container, {
            proxy  = proxy,
            key    = key,
            prefix = prefix .. ".value_container",
          })
        end
      end
    end
  end

end
