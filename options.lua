local function main_channel()
    local f = io.open("settings/main_channel.txt", "r")
    if f == nil then return 0 end
    local ch = f:read()
    f:close()
    return ch
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

return {main_channel = main_channel, pairsByKeys = pairsByKeys}