local json = require("json")

local function read_settings()
    local f = io.open("settings/settings.json", "r")
    if f == nil then return 0 end
    local ch = f:read()
    f:close()
    return ch
end

local function write_settings(data)
    local f = io.open("settings/settings.json", "w")
    if f == nil then return 0 end
    f:write(data)
    f:close()
end

local function get_data(key)
    local decoded = json.decode(read_settings)
    return decoded[key]
end

local function save_data(key, data)
    local decoded = json.decode(read_settings)
    decoded[key] = data
    write_settings(json.encode(decoded))
end

local function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
      i = i + 1
      if a[i] == nil then return nil
      else return a[i], t[a[i]]
      end
    end
    return iter
end

local function starts_with(text, prefix)
    return text:find(prefix, 1, true) == 1
end

return {get_data = get_data, pairsByKeys = pairsByKeys, starts_with = starts_with, save_data = save_data}