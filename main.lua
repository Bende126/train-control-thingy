if shell.dir() ~= "/" then shell.setDir("/") end

local settings = require("settings")
local peripheral_list = require("peripherals")

local function determine_track_number()
    --[[
    calculates the number of loading ports on each of the "arteries" and summs it
    ]]

    local unique_tracks = {}
    for _, v in pairs(peripheral_list.get_interfaces()) do
        if (unique_tracks[v.track]) == nil then
            unique_tracks[v.track] = true
        end
    end

    return {lenght = table.getn(unique_tracks),
            tracks = unique_tracks}
end


--[[  #### Recursive arterie search 'casue why not? <br />
 `current`: the current line we are in. Default nil <br />
 `remaining`: the things we are searching in. Default nil <br />
 `save`: where to save the the arterie thingies. Default nil <br />
 `key`: the key that contains the current table in the remaining table. Default nil <br />
 If any of the params are nil it wont run ]]
local function recursive_magic(t)

    setmetatable(t, {__index = {
        current = nil,
        remaining = nil,
        save = nil,
        key = nil
    }})
    local current = t.current
    local remaining = t.remaining
    local save = t.save
    local key = t.key

    if not current or not remaining or not save or not key then return nil end

    local track_switch = string.sub(current.name, 13)
    local from = string.sub(track_switch, 1, 1)
    local i = 1
    while table.getn(remaining) > 0  do

        local track_switch = string.sub(remaining[i].name, 13)
        local to = string.sub(track_switch, -1)

        if tonumber(from) == tonumber(to) then
            save[#save+1] = current
            local curr = remaining[i]
            remaining[i] = nil

            recursive_magic{
                current = curr,
                remaining = remaining,
                save = save
            }
        end
        i = i+1
    end

end

local function determine_arterie_number()
    local arteries = {}
    local switches = peripheral_list.partial_find("train_switch:")

    local i = 1
    while table.getn(switches) > 0  do
        local tmp = {}
        local curr = switches[i]
        switches[i] = nil
        recursive_magic{
            current = curr,
            remaining = switches,
            save = tmp
        }
        arteries[tostring(i)] = tmp
        i = i+1
    end
   
    return arteries
end

local tracks = determine_track_number()
local arteries = determine_arterie_number()