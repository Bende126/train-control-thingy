local function main_channel()
    local tmp = {}
    for line in io.lines("settings/main_channel.txt") do
        tmp[#tmp+1] = line
    end
    return tmp[1]
end

print(main_channel())

return {main_channel = main_channel}