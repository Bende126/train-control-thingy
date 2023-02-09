local function main_channel()
    local f = io.open("settings/main_channel.txt", "r")
    if f == nil then return 0 end
    local ch = f:read()
    f:close()
    return ch
end

return {main_channel = main_channel}